// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import UUIDExtensions

struct DataStoreTypeTests {
    @Test
    func valuesAreUnique() {
        let authenticatedData = Data("test".utf8)
        let allDataStoreTypes: [DataStoreType] = [
            .inMemory,
            .persistent,
            .securePersistent(key: SymmetricKey(size: .bits128)),
            .securePersistent(key: SymmetricKey(size: .bits128), authenticatedData: authenticatedData),
            .securePersistent(key: SymmetricKey(size: .bits256), authenticatedData: authenticatedData),
            .securePersistent(key: SymmetricKey(size: .bits256)),
            .securePersistent(key: SymmetricKey(size: .bits192)),
        ]

        var allPossibleCases: [(lhs: DataStoreType, rhs: DataStoreType)] = []
        for (offset, dataStoreType) in allDataStoreTypes.enumerated() {
            for other in allDataStoreTypes.dropFirst(offset + 1) {
                allPossibleCases.append((dataStoreType, other))
            }
        }

        // Sanity check to make sure we have the expected number of cases.
        #expect(allPossibleCases.count == 21)

        for (lhs, rhs) in allPossibleCases {
            #expect(lhs != rhs)
            #expect(lhs.hashValue != rhs.hashValue)
        }
    }

    @Test
    func resolveExpectedDataStore() {
        #expect(DataStoreType.inMemory.resolveDataStore() is InMemoryDataStore)
        #expect(DataStoreType.persistent.resolveDataStore() is PersistentDataStore)
        let key = SymmetricKey(size: .bits128)
        #expect(DataStoreType.securePersistent(key: key).resolveDataStore() is SecurePersistentDataStore)
    }
}
