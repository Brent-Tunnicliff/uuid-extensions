// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import SwiftUUID
import Testing

#if canImport(FoundationEssentials)
    import FoundationEssentials
#elseif canImport(Foundation)
    import Foundation
#else
    #error("SwiftUUID requires Foundation or FoundationEssentials")
#endif

struct UUIDMacroTests {
    @Test
    func returnsExpectedValue() {
        let uuidValue = "95034084-7faa-4311-88dc-3cbc8052b359"
        let result = #uuid("95034084-7faa-4311-88dc-3cbc8052b359")
        #expect(result.uuidString.lowercased() == uuidValue)
    }
}
