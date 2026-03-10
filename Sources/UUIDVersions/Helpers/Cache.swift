// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

protocol Cache: Sendable {
    var randomNode: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)? { get nonmutating set }
}

extension Cache where Self == UserDefaultsCache {
    static var `default`: Self { .shared }
}

final class UserDefaultsCache: Cache {
    static let shared = UserDefaultsCache()

    private let lock = NSLock()
    private let userDefaults: UserDefaults

    private let randomNodeKey = UUID.randomNodeKey.uuidString
    var randomNode: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)? {
        get {
            lock.withLock {
                guard
                    let cachedValue = userDefaults.value(forKey: randomNodeKey),
                    let bytes = cachedValue as? (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
                else {
                    return nil
                }

                return bytes
            }
        }
        set {
            lock.withLock {
                userDefaults.setValue(newValue, forKey: randomNodeKey)
            }
        }
    }

    private convenience init() {
        let suiteName = UUID.userDefaultsCacheSuiteName
        guard let userDefaults = UserDefaults(suiteName: suiteName.uuidString) else {
            preconditionFailure("Unable to create UserDefaults with suite name \(suiteName.uuidString)")
        }

        self.init(userDefaults: userDefaults)
    }

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

// Not using `Synchronization` so we can keep the minimum OS versions as low as possible.
extension UserDefaultsCache: @unchecked Sendable {}

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

    fileprivate static let userDefaultsCacheSuiteName = UUID(
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
