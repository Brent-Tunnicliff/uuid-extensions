// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import UUIDExtensions

struct WrappedRandomNodeValueTests {
    @Test
    func initWithNilReturnsNil() {
        #expect(WrappedRandomNodeValue(nil) == nil)
    }

    @Test
    func unwrapReturnsOriginal() throws {
        let originalValue: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) = (0x06, 0x03, 0x01, 0x04, 0x02, 0x05)
        let wrapped = try #require(WrappedRandomNodeValue(originalValue))
        let unwrapped = wrapped.unwrapped

        #expect(unwrapped.0 == originalValue.0)
        #expect(unwrapped.1 == originalValue.1)
        #expect(unwrapped.2 == originalValue.2)
        #expect(unwrapped.3 == originalValue.3)
        #expect(unwrapped.4 == originalValue.4)
        #expect(unwrapped.5 == originalValue.5)
    }
}
