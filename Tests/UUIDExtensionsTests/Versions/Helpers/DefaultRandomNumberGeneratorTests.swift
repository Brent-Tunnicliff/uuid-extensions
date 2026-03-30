// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing
@testable import UUIDExtensions

/// These tests are just sanity tests that the results appear to be roughly right
/// and not causing crashes with incorrect data size.
struct DefaultRandomNumberGeneratorTests {
    private let randomNumberGenerator = DefaultRandomNumberGenerator()
    private let rangeOfIterations = 0..<100_000

    @Test
    func clockSequence() {
        /// Max value of 14 bits.
        let maxValue: UInt16 = 16_383
        let expectedRange: ClosedRange<UInt16> = 0...maxValue
        for _ in rangeOfIterations {
            #expect(expectedRange.contains(randomNumberGenerator.clockSequence))
        }
    }

    @Test
    func int48() {
        // Max value of 48 bits.
        let maxValue: UInt64 = 0xFF_FF_FF_FF_FF_FF
        let expectedRange: ClosedRange<UInt64> = 0...maxValue
        for _ in rangeOfIterations {
            #expect(expectedRange.contains(randomNumberGenerator.int48))
        }
    }
}
