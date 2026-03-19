// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

protocol RandomNumberGenerator: Sendable {
    /// Returns a random 48 bit number.
    var int48: UInt64 { get }

    /// Returns a random value for [Variant](https://www.rfc-editor.org/rfc/rfc9562#name-variant-field) (8,9,A,B).
    var variant: UInt8 { get }
}

extension RandomNumberGenerator where Self == DefaultRandomNumberGenerator {
    static var `default`: Self { .shared }
}

struct DefaultRandomNumberGenerator: RandomNumberGenerator {
    static let shared = DefaultRandomNumberGenerator()

    var int48: UInt64 {
        UInt64.random(in: 0..<(1 << 48))
    }

    var variant: UInt8 {
        UInt8.random(in: 0x80...0xb0)
    }

    private init() {}
}
