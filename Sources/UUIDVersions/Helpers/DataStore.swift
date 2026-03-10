// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    import FoundationEssentials
#endif

#if canImport(Foundation)
    import Foundation
#endif

protocol DataStore: Sendable {
    var randomNode: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)? { get nonmutating set }
}

extension DataStore where Self == UserDefaultsDataStore {
    static var `default`: Self { .shared }
}

final class UserDefaultsDataStore: DataStore {
    static let shared = UserDefaultsDataStore()

    private let store: Store

    private let randomNodeKey = UUID.randomNodeKey.uuidString
    var randomNode: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)? {
        get {
            guard
                let cachedValue = store.getValue(forKey: randomNodeKey),
                let bytes = cachedValue as? (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
            else {
                return nil
            }

            return bytes
        }
        set {
            store.set(newValue, forKey: randomNodeKey)
        }
    }

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

extension UserDefaultsDataStore {
    fileprivate final class Store {
        private let lock = NSLock()
        private let userDefaults: UserDefaults

        init(userDefaults: UserDefaults) {
            self.userDefaults = userDefaults
        }

        func getValue(forKey key: String) -> Any? {
            lock.withLock {
                userDefaults.value(forKey: key)
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

        /// `FoundationEssentials` has
        /// [a bug](https://github.com/swiftlang/swift-corelibs-foundation/issues/4837#issuecomment-2726327549)
        /// where UserDefaults does not write to disk unless we call `synchronize()`manually.
        ///
        /// But lets not block the current thread, this probably does not need to be immediate.
        /// For `Foundation` based platforms, we should be able to just let it handle syncing automatically so this function does nothing.
        @concurrent
        private func synchronize() async {
            #if canImport(FoundationEssentials)
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
