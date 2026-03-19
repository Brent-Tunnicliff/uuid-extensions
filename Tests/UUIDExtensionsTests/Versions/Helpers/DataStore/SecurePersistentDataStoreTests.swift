// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import UUIDExtensions

struct SecurePersistentDataStoreTests {
    @Test(arguments: [true, false])
    func randomNode(withAuthenticatedData: Bool) throws {
        let userDefaults = try #require(UserDefaults.forTest())
        let key = SymmetricKey(size: .bits256)
        let dataStore = SecurePersistentDataStore(
            authenticatedData: withAuthenticatedData ? Data("test".utf8) : nil,
            key: key,
            userDefaults: userDefaults
        )

        let originalValue = WrappedRandomNodeValue((0x01, 0x02, 0x03, 0x04, 0x05, 0x06))

        dataStore.randomNode = originalValue

        // We expect the value to be persisted.
        _ = try #require(userDefaults.object(forKey: PersistentDataStore.randomNodeKey))

        // Calling the get again returns the same value.
        #expect(dataStore.randomNode == originalValue)

        userDefaults.tearDown()
    }
}
