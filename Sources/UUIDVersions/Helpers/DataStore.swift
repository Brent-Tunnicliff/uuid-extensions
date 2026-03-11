// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

protocol DataStore: Sendable {
    var randomNode: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)? { get nonmutating set }
}

extension DataStore where Self == UserDefaultsDataStore {
    static var `default`: Self { .shared }
}

final class UserDefaultsDataStore {
    static let shared = UserDefaultsDataStore()

    private let store: Store

    private convenience init() {
        let suiteName = UUID.userDefaultsDataStoreSuiteName
        guard let userDefaults = UserDefaults(suiteName: suiteName.uuidString) else {
            preconditionFailure("Unable to create UserDefaults with suite name \(suiteName.uuidString)")
        }

        self.init(userDefaults: userDefaults)
    }

    init(userDefaults: UserDefaults) {
        self.store = Store(userDefaults: userDefaults)
    }
}

extension UserDefaultsDataStore: DataStore {
    static var randomNodeKey: String { UUID.randomNodeKey.uuidString }
    var randomNode: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)? {
        get {
            guard
                let cachedValue = store.getValue(forKey: Self.randomNodeKey),
                let data = cachedValue as? Data,
                let wrappedValue = try? JSONDecoder().decode(WrappedRandomNodeValue.self, from: data)
            else {
                return nil
            }

            return wrappedValue.unwrapped
        }
        set {
            let wrappedValue = WrappedRandomNodeValue(newValue)
            let data = try? JSONEncoder().encode(wrappedValue)
            store.set(data, forKey: Self.randomNodeKey)
        }
    }

    struct WrappedRandomNodeValue: Codable {
        let index0: UInt8
        let index1: UInt8
        let index2: UInt8
        let index3: UInt8
        let index4: UInt8
        let index5: UInt8

        var unwrapped: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) {
            (index0, index1, index2, index3, index4, index5)
        }

        init?(_ value: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)?) {
            guard let value else {
                return nil
            }

            self.index0 = value.0
            self.index1 = value.1
            self.index2 = value.2
            self.index3 = value.3
            self.index4 = value.4
            self.index5 = value.5
        }
    }
}

extension UserDefaultsDataStore {
    fileprivate final class Store {
        private let lock = NSLock()
        private let userDefaults: UserDefaults

        init(userDefaults: UserDefaults) {
            self.userDefaults = userDefaults
        }

        func getValue(forKey key: String) -> Any? {
            lock.withLock {
                userDefaults.object(forKey: key)
            }
        }

        func set(_ value: Any?, forKey key: String) {
            lock.withLock {
                userDefaults.set(value, forKey: key)
            }

            Task {
                await synchronize()
            }
        }

        /// non-Darwin platforms have a
        /// [bug](https://github.com/swiftlang/swift-corelibs-foundation/issues/4837#issuecomment-2726327549)
        /// where UserDefaults does not write to disk unless we call `synchronize()`manually.
        ///
        /// But lets not block the current thread, this probably does not need to be immediate.
        /// For Darwin based platforms, we should be able to just let it handle syncing automatically so this function does nothing.
        @concurrent
        private func synchronize() async {
            #if !canImport(Darwin)
                lock.withLock {
                    _ = userDefaults.synchronize()
                }
            #endif
        }
    }
}

// Not using `Synchronization` so we can keep the minimum OS versions as low as possible.
extension UserDefaultsDataStore.Store: @unchecked Sendable {}

// Using uuids for suite name and keys just to make these a little more obscure to find unless you know where to look.
extension UUID {
    fileprivate static let randomNodeKey = UUID(
        uuid: (
            0xa6,
            0x21,
            0xad,
            0x54,
            0x1b,
            0x18,
            0x5c,
            0x62,
            0xae,
            0x73,
            0xf0,
            0x7b,
            0x36,
            0xca,
            0xb4,
            0x86
        )
    )

    fileprivate static let userDefaultsDataStoreSuiteName = UUID(
        uuid: (
            0x0b,
            0x36,
            0x67,
            0x86,
            0x88,
            0xe7,
            0x5c,
            0xe2,
            0x87,
            0xc7,
            0xfe,
            0xcd,
            0x80,
            0x61,
            0x30,
            0x88
        )
    )
}
