// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import UUIDVersions

struct InMemoryDataStoreTests {
    @Test
    func randomNode() throws {
        let dataStore = InMemoryDataStore()
        let originalValue = WrappedRandomNodeValue((0x01, 0x02, 0x03, 0x04, 0x05, 0x06))

        dataStore.randomNode = originalValue

        // Calling the get again returns the same value.
        #expect(dataStore.randomNode == originalValue)
    }
}
