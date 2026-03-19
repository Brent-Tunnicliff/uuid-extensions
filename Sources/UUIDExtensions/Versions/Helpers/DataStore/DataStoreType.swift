// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import Foundation

// MARK: - DataStoreType

/// Represents the type of DataStore system to be used when generating UUID's.
public struct DataStoreType {
    let value: Value
}

extension DataStoreType {
    /// Maintains data in memory only.
    ///
    /// - Warning: If the program terminates all data is lost. Launching again will be in an empty state.
    public static let inMemory = DataStoreType(value: .inMemory)

    /// Maintains data on disk.
    ///
    /// - Warning: Data is not encrypted. The data may be plain text readable.
    public static let persistent = DataStoreType(value: .persistent)

    /// Maintains data on disk using AES/GCM encryption cipher.
    ///
    /// - Parameters:
    ///   - key: The ``SymmetricKey`` used for encrypting and decrypting the values.
    ///   - authenticatedData: Additional data to be authenticated.
    /// - Returns: Configured data store type for secure persistence.
    public static func securePersistent(key: SymmetricKey, authenticatedData: Data? = nil) -> DataStoreType {
        DataStoreType(value: .securePersistent(key: key, authenticatedData: authenticatedData))
    }
}

extension DataStoreType {
    func resolveDataStore() -> any DataStore {
        switch value {
        case .inMemory:
            InMemoryDataStore.shared
        case .persistent:
            PersistentDataStore.shared
        case let .securePersistent(key, authenticatedData):
            SecurePersistentDataStore(authenticatedData: authenticatedData, key: key)
        }
    }
}

// MARK: Hashable

extension DataStoreType: Hashable {}

// MARK: Sendable

extension DataStoreType: Sendable {}

// MARK: - DataStoreType.Value

extension DataStoreType {
    enum Value {
        case inMemory
        case persistent
        case securePersistent(key: SymmetricKey, authenticatedData: Data?)
    }
}

// MARK: Hashable

extension DataStoreType.Value: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .inMemory:
            hasher.combine("inMemory")
        case .persistent:
            hasher.combine("persistent")
        case let .securePersistent(key, authenticatedData):
            hasher.combine("securePersistent")
            hasher.combine(key)
            hasher.combine(authenticatedData)
        }
    }
}

// MARK: Sendable

extension DataStoreType.Value: Sendable {}
