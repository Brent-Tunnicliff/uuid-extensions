// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import UUIDExtensions

@Suite("UUID+UserDefaultsTests")
struct UUIDUserDefaultsTests {
    @Test
    func valuesAreUnique() {
        #expect(UUID.persistentDataStoreSuiteName != UUID.randomNodeKey)
        #expect(UUID.persistentDataStoreSuiteName != UUID.securePersistentDataStoreSuiteName)
        #expect(UUID.randomNodeKey != UUID.securePersistentDataStoreSuiteName)
    }
}
