// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

@testable import UUIDExtensions

struct MockRandomNumberGenerator: RandomNumberGenerator {
    let int48: UInt64
    let variant: UInt8

    init(
        int48: UInt64 = 0x9E_6B_DE_CE_D8_46,
        variant: UInt8 = 0x80
    ) {
        self.int48 = int48
        self.variant = variant
    }
}
