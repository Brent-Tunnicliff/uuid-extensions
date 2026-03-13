// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

// MARK: - UUIDVersion

extension UUIDVersion {
    /// [UUID version 1](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-1).
    ///
    /// The MAC address is not being used to generate the due to
    /// the complexity of getting that value across different platforms.
    /// Sets the data store as persistent so relaunches can use the same random node.
    ///
    /// - Warning: Recommended to use ``v4`` instead if possible.
    public static let v1 = v1(dataStore: .persistent)

    /// [UUID version 1](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-1).
    ///
    /// The MAC address is not being used to generate the due to
    /// the complexity of getting that value across different platforms.
    ///
    /// - Parameter dataStore: The type of data store to be used when generating the node for the UUID.
    /// - Warning: Recommended to use ``v4`` instead if possible.
    /// - Returns: ``UUIDVersion`` configured as `v1` and containing the input dataStore.
    public static func v1(dataStore: DataStoreType) -> UUIDVersion {
        UUIDVersion(.v1, generator: VersionOneUUIDGenerator(dataStore: dataStore))
    }
}

// MARK: - VersionOneUUIDGenerator

/// Used for generating [UUID version 1](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-1).
final class VersionOneUUIDGenerator {
    private let dateService: any DateService
    private let nodeService: any NodeService
    private let randomNumberGenerator: any RandomNumberGenerator
    private let state: State

    fileprivate convenience init(dataStore: DataStoreType) {
        self.init(
            dateService: .default,
            nodeService: DefaultNodeService(dataStore: dataStore),
            randomNumberGenerator: .default,
            state: .shared
        )
    }

    init(
        dateService: any DateService,
        nodeService: any NodeService,
        randomNumberGenerator: any RandomNumberGenerator,
        state: State
    ) {
        self.dateService = dateService
        self.nodeService = nodeService
        self.randomNumberGenerator = randomNumberGenerator
        self.state = state
    }
}

// MARK: UUIDGenerator

extension VersionOneUUIDGenerator: UUIDGenerator {
    /// Generated a new UUID of version 1.
    func new() -> UUID {
        // UUID epoch offset (1582-10-15 → 1970-01-01) in 100ns units
        let uuidEpoch: UInt64 = 0x01B_21D_D21_381_400_0

        // Handle clock rollback
        let now = dateService.now().timeIntervalSince1970
        let timestamp = UInt64(now * 10_000_000) + uuidEpoch
        let clockSequence: UInt16
        if timestamp <= state.previousTimestamp {
            // new time stamp is less than last time, so advance clock sequence to avoid possible collisions.
            clockSequence = state.advanceClockSequence()
        } else {
            clockSequence = state.clockSequence
        }

        state.previousTimestamp = timestamp

        let timeLow = UInt32(timestamp & 0xFFF_FFF_FF)
        let timeMid = UInt16((timestamp >> 32) & 0xFFFF)
        var timeHi = UInt16((timestamp >> 48) & 0x0FFF)
        // version 1
        timeHi |= 0x1000

        var clockSeqHi = UInt8((clockSequence >> 8) & 0x3F)

        // Variant A
        clockSeqHi |= randomNumberGenerator.variantA

        let clockSeqLow = UInt8(clockSequence & 0xFF)
        let node = nodeService.node

        return UUID(
            uuid: (
                // time_low
                UInt8((timeLow >> 24) & 0xFF),
                UInt8((timeLow >> 16) & 0xFF),
                UInt8((timeLow >> 8) & 0xFF),
                UInt8(timeLow & 0xFF),

                // time_mid
                UInt8((timeMid >> 8) & 0xFF),
                UInt8(timeMid & 0xFF),

                // ver & time_high
                UInt8((timeHi >> 8) & 0xFF),
                UInt8(timeHi & 0xFF),

                // var & clock_seq
                clockSeqHi,
                clockSeqLow,

                // node
                node.0,
                node.1,
                node.2,
                node.3,
                node.4,
                node.5,
            )
        )
    }
}

// MARK: - VersionOneUUIDGenerator.State

extension VersionOneUUIDGenerator {
    /// Maintains the state of the generator.
    ///
    /// Wraps access in locks to make it safe to be Sendable.
    final class State {
        static let shared = State()

        private let lock = NSLock()

        private var _clockSequence = UInt16.random(in: 0..<16384)
        var clockSequence: UInt16 {
            get { lock.withLock { _clockSequence } }
            set { lock.withLock { _clockSequence = newValue } }
        }

        private var _previousTimestamp: UInt64 = 0
        var previousTimestamp: UInt64 {
            get { lock.withLock { _previousTimestamp } }
            set { lock.withLock { _previousTimestamp = newValue } }
        }

        private init() {}

        /// Advances the clockSequence state for avoiding collisions.
        ///
        /// - Returns: The new generated clock sequence.
        func advanceClockSequence() -> UInt16 {
            lock.withLock {
                _clockSequence = (_clockSequence + 1) & 0x3FFF
                return _clockSequence
            }
        }
    }
}

// MARK: Sendable

// Not using `Synchronization` so we can keep the minimum OS versions as low as possible.
extension VersionOneUUIDGenerator.State: @unchecked Sendable {}
