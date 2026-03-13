// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import UUIDVersions

struct PersistentDataStoreTests {
    private let userDefaults: UserDefaults
    private let dataStore: PersistentDataStore

    init() throws {
        self.userDefaults = try #require(UserDefaults(suiteName: "UserDefaultsDataStoreTests"))
        self.dataStore = PersistentDataStore(userDefaults: userDefaults)
    }

    @Test
    func randomNode() throws {
        let originalValue = WrappedRandomNodeValue((0x01, 0x02, 0x03, 0x04, 0x05, 0x06))
        dataStore.randomNode = originalValue

        // We expect the value to be persisted.
        _ = try #require(userDefaults.object(forKey: PersistentDataStore.randomNodeKey))

        // Calling the get again returns the same value.
        #expect(try #require(dataStore.randomNode) == originalValue)
    }
}
