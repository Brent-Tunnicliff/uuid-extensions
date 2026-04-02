// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing
@testable import UUIDExtensions

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

@Suite("UUID+UserDefaultsTests")
struct UUIDUserDefaultsTests {
    @Test
    func valuesAreUnique() {
        #expect(UUID.persistentDataStoreSuiteName != UUID.randomNodeKey)
        #expect(UUID.persistentDataStoreSuiteName != UUID.securePersistentDataStoreSuiteName)
        #expect(UUID.randomNodeKey != UUID.securePersistentDataStoreSuiteName)
    }
}
