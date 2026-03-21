// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

protocol RandomNumberGenerator: Sendable {
    /// Returns a new valid clock sequence number.
    var clockSequence: UInt16 { get }

    /// Returns a random 48 bit number.
    var int48: UInt64 { get }

    /// Returns a random value for [Variant](https://www.rfc-editor.org/rfc/rfc9562#name-variant-field).
    var variant: UInt8 { get }
}

extension RandomNumberGenerator where Self == DefaultRandomNumberGenerator {
    static var `default`: Self { .shared }
}

struct DefaultRandomNumberGenerator: RandomNumberGenerator {
    static let shared = DefaultRandomNumberGenerator()

    var clockSequence: UInt16 {
        UInt16.random(in: 0..<16384)
    }

    var int48: UInt64 {
        UInt64.random(in: 0..<(1 << 48))
    }

    var variant: UInt8 {
        let values: [UInt8] = [0x80, 0x90, 0xa0, 0xb0]
        let index = Int.random(in: 0..<values.count)
        return values[index]
    }

    private init() {}
}
