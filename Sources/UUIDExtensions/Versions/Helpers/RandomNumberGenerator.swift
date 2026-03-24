// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

protocol RandomNumberGenerator: Sendable {
    /// Returns a random byte number.
    var byte: UInt8 { get }

    /// Returns a new valid clock sequence number.
    var clockSequence: UInt16 { get }

    /// Returns a random 48 bit number.
    var int48: UInt64 { get }

    /// Returns a random value for [Variant](https://www.rfc-editor.org/rfc/rfc9562#name-variant-field).
    var variant: UInt8 { get }

    func bytes(size: Int) -> [UInt8]

    func of(size: UInt16) -> UInt16
}

extension RandomNumberGenerator where Self == DefaultRandomNumberGenerator {
    static var `default`: Self {
        DefaultRandomNumberGenerator()
    }
}

struct DefaultRandomNumberGenerator: RandomNumberGenerator {
    var byte: UInt8 {
        UInt8.random(in: 0...255)
    }

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

    func bytes(size: Int) -> [UInt8] {
        (0..<size).map { _ in
            byte
        }
    }

    func of(size: UInt16) -> UInt16 {
        UInt16.random(in: 0..<size)
    }
}
