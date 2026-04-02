// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing
import UUIDExtensions

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

#if canImport(UUIDMacros)
    private let disabled = false
#else
    private let disabled = true
#endif

@Suite(.disabled(if: disabled, "Unable to test macros on this platform"))
struct UUIDMacroTests {
    @Test
    func returnsExpectedValue() {
        #if canImport(UUIDMacros)
            let uuidValue = "95034084-7faa-4311-88dc-3cbc8052b359"
            let result = #uuid("95034084-7faa-4311-88dc-3cbc8052b359")
            #expect(result.uuidString.lowercased() == uuidValue)
        #endif
    }
}
