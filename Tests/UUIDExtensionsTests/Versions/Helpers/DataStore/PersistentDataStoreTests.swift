// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import UUIDExtensions

struct PersistentDataStoreTests {
    @Test
    func randomNode() throws {
        let userDefaults = try #require(UserDefaults.forTest())
        let store = PersistentDataStore.Store(userDefaults: userDefaults)
        let dataStore = PersistentDataStore(store: store)
        let originalValue = WrappedRandomNodeValue((0x01, 0x02, 0x03, 0x04, 0x05, 0x06))
        dataStore.randomNode = originalValue

        // We expect the value to be persisted.
        _ = try #require(userDefaults.object(forKey: UUID.randomNodeKey.uuidString))

        // Calling the get again returns the same value.
        #expect(dataStore.randomNode == originalValue)

        userDefaults.tearDown()
    }
}
