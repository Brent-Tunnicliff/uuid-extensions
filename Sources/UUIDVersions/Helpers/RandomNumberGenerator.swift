// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

protocol RandomNumberGenerator: Sendable {
    /// Returns a random 48 bit number.
    var int48: UInt64 { get }
}

extension RandomNumberGenerator where Self == DefaultRandomNumberGenerator {
    static var `default`: Self { .shared }
}

struct DefaultRandomNumberGenerator: RandomNumberGenerator {
    static let shared = DefaultRandomNumberGenerator()

    var int48: UInt64 {
        UInt64.random(in: 0..<(1 << 48))
    }

    private init() {}
}
