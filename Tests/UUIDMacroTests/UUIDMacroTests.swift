// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing
import UUIDMacro

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

struct UUIDMacroTests {
    @Test
    func returnsExpectedValue() {
        let uuidValue = "95034084-7faa-4311-88dc-3cbc8052b359"
        let result = #uuid("95034084-7faa-4311-88dc-3cbc8052b359")
        #expect(result.uuidString.lowercased() == uuidValue)
    }
}
