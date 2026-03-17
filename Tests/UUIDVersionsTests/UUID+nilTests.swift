// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
import UUIDVersions

@Suite("UUID+nilTests")
struct UUIDNilTests {
    @Test
    func containsExpectedValue() {
        #expect(UUID.nil.uuidString == "00000000-0000-0000-0000-000000000000")
    }
}
