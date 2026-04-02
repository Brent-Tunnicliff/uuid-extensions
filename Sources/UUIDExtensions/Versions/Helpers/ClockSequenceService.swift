// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

/// Maintains the state of clock sequence.
///
/// State is only maintained in memory as loosing on program reset is not an issue.
final class ClockSequenceService {
    static let shared = ClockSequenceService()

    /// Wraps access in locks to make it safe to be Sendable.
    private let lock = NSLock()

    private var clockSequence: UInt16
    private var previousTimestamp: UInt64 = 0

    convenience init() {
        let randomNumberGenerator: any RandomNumberGenerator = .default
        self.init(
            clockSequence: randomNumberGenerator.clockSequence,
            previousTimestamp: 0
        )
    }

    init(
        clockSequence: UInt16,
        previousTimestamp: UInt64
    ) {
        self.clockSequence = clockSequence
        self.previousTimestamp = previousTimestamp
    }

    /// Retrieves the clock sequence.
    ///
    /// - Parameters:
    ///   - timestamp: The timestamp for determining if the clock was moved backwards.
    ///     If it is lower than the current cached value then the cached clock sequence is incremented before returning.
    ///   - clockSequenceIncrement: The value to increment the clock sequence if the timestamp is
    ///     lower than the previous cached value.
    /// - Returns: The cached clock sequence.
    func getClockSequence(
        timestamp: UInt64,
        clockSequenceIncrement: UInt16 = 1
    ) -> UInt16 {
        lock.withLock {
            let clockSequence: UInt16
            if timestamp <= previousTimestamp {
                // new time stamp is less than last time, so advance clock sequence to avoid possible collisions.
                clockSequence = (self.clockSequence + clockSequenceIncrement) & 0x3FFF
                self.clockSequence = clockSequence
            } else {
                clockSequence = self.clockSequence
            }

            previousTimestamp = timestamp

            return clockSequence
        }
    }
}

// MARK: Sendable

// Not using `Synchronization` so we can keep the minimum OS versions as low as possible.
extension ClockSequenceService: @unchecked Sendable {}
