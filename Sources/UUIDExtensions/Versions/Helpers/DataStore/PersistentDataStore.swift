// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

// MARK: - PersistentDataStore

struct PersistentDataStore {
    private let store: Store

    init() {
        self.init(store: .shared)
    }

    init(store: Store) {
        self.store = store
    }
}

// MARK: DataStore

extension PersistentDataStore: DataStore {
    var randomNode: WrappedRandomNodeValue? {
        get {
            guard
                let cachedValue = store.getValue(forKey: .randomNodeKey),
                let data = cachedValue as? Data,
                let wrappedValue = try? JSONDecoder().decode(WrappedRandomNodeValue.self, from: data)
            else {
                return nil
            }

            return wrappedValue
        }
        nonmutating set {
            let wrappedValue = newValue
            let data = try? JSONEncoder().encode(wrappedValue)
            store.set(data, forKey: .randomNodeKey)
        }
    }
}

// MARK: - PersistentDataStore.Store

extension PersistentDataStore {
    final class Store {
        private let lock = NSLock()
        private let userDefaults: UserDefaults

        init(userDefaults: UserDefaults) {
            self.userDefaults = userDefaults
        }

        func getValue(forKey key: UUID) -> Any? {
            lock.withLock {
                userDefaults.object(forKey: key.uuidString)
            }
        }

        func set(_ value: Any?, forKey key: UUID) {
            lock.withLock {
                userDefaults.set(value, forKey: key.uuidString)
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

extension PersistentDataStore.Store {
    fileprivate static let shared: PersistentDataStore.Store = {
        let suiteName = UUID.persistentDataStoreSuiteName
        guard let userDefaults = UserDefaults(suiteName: suiteName.uuidString) else {
            preconditionFailure("Unable to create UserDefaults with suite name \(suiteName.uuidString)")
        }

        return PersistentDataStore.Store(userDefaults: userDefaults)
    }()
}

// MARK: Sendable

// Not using `Synchronization` so we can keep the minimum OS versions as low as possible.
extension PersistentDataStore.Store: @unchecked Sendable {}
