// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import UUIDVersions

struct ClockSequenceServiceTests {
    private let clockSequence: UInt16 = 0x33C8
    private let previousTimestamp: UInt64 = 1000
    private let clockSequenceService: ClockSequenceService

    init() {
        self.clockSequenceService = ClockSequenceService(
            clockSequence: clockSequence,
            previousTimestamp: previousTimestamp
        )
    }

    @Test
    func getClockSequenceWithLaterTimestampReturnsCachedValue() {
        let timestamp = previousTimestamp + 100
        #expect(clockSequenceService.getClockSequence(timestamp: timestamp) == clockSequence)
    }

    @Test
    func getClockSequenceWithEarlierTimestampReturnsAdvancedValue() {
        let expectedClockSequence: UInt16 = 0x33C9
        let earlierTimestamp = previousTimestamp - 100
        #expect(clockSequenceService.getClockSequence(timestamp: earlierTimestamp) == expectedClockSequence)

        // Lets check that the advanced clockSequence was cached and continues to be returned.
        let laterTimestamp = previousTimestamp + 100
        #expect(clockSequenceService.getClockSequence(timestamp: laterTimestamp) == expectedClockSequence)
    }
}
