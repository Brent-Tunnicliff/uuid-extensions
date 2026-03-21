// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Crypto
import Foundation

struct SecurePersistentDataStore {
    private let authenticatedData: Data?
    private let key: SymmetricKey
    private let store: PersistentDataStore.Store

    init(
        authenticatedData: Data?,
        key: SymmetricKey
    ) {
        self.authenticatedData = authenticatedData
        self.key = key
        self.store = .securePersistent
    }

    init(
        authenticatedData: Data?,
        key: SymmetricKey,
        userDefaults: UserDefaults
    ) {
        self.authenticatedData = authenticatedData
        self.key = key
        self.store = PersistentDataStore.Store(userDefaults: userDefaults)
    }
}

extension PersistentDataStore.Store {
    fileprivate static let securePersistent: PersistentDataStore.Store = {
        let suiteName = UUID.securePersistentDataStoreSuiteName
        guard let userDefaults = UserDefaults(suiteName: suiteName.uuidString) else {
            preconditionFailure("Unable to create UserDefaults with suite name \(suiteName.uuidString)")
        }

        return PersistentDataStore.Store(userDefaults: userDefaults)
    }()
}

// MARK: DataStore

extension SecurePersistentDataStore: DataStore {
    static var randomNodeKey: String { UUID.randomNodeKey.uuidString }
    var randomNode: WrappedRandomNodeValue? {
        get {
            guard
                let cachedValue = store.getValue(forKey: Self.randomNodeKey),
                let data = cachedValue as? Data,
                let wrappedValue: WrappedRandomNodeValue = try? decrypt(data)
            else {
                return nil
            }

            return wrappedValue
        }
        nonmutating set {
            store.set(
                newValue.map { try? encrypt($0) } ?? nil,
                forKey: Self.randomNodeKey
            )
        }
    }

    private func decrypt<Value>(_ data: Data) throws -> Value where Value: Decodable {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let opened =
            if let authenticatedData {
                try AES.GCM.open(sealedBox, using: key.wrapped, authenticating: authenticatedData)
            } else {
                try AES.GCM.open(sealedBox, using: key.wrapped)
            }

        return try JSONDecoder().decode(Value.self, from: opened)
    }

    private func encrypt<Value>(_ value: Value) throws -> Data where Value: Encodable {
        let data = try JSONEncoder().encode(value)

        let sealedBox =
            if let authenticatedData {
                try AES.GCM.seal(data, using: key.wrapped, authenticating: authenticatedData)
            } else {
                try AES.GCM.seal(data, using: key.wrapped)
            }

        guard let combined = sealedBox.combined else {
            throw Error.unableToGetSealedBoxCombinedData
        }

        return combined
    }

    enum Error: Swift.Error {
        case unableToGetSealedBoxCombinedData
    }
}
