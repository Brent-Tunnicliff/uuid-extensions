// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
import UUIDVersions

@Suite("UUID+maxTests")
struct UUIDMaxTests {
    @Test
    func containsExpectedValue() {
        #expect(UUID.max.uuidString == "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF")
    }
}
