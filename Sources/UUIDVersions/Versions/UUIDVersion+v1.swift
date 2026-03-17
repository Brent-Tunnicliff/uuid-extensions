// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

// MARK: - UUIDVersion

extension UUIDVersion {
    /// [UUID version 1](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-1).
    ///
    /// The MAC address is not being used to generate the due to
    /// the complexity of getting that value across different platforms.
    /// Sets the data store as persistent so relaunches can use the same random node.
    public static let v1 = v1(dataStore: .persistent)

    /// [UUID version 1](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-1).
    ///
    /// The MAC address is not being used to generate the due to
    /// the complexity of getting that value across different platforms.
    ///
    /// - Parameter dataStore: The type of data store to be used when generating the node for the UUID.
    /// - Returns: ``UUIDVersion`` configured as `v1` and containing the input dataStore.
    public static func v1(dataStore: DataStoreType) -> UUIDVersion {
        UUIDVersion(generator: VersionOneUUIDGenerator(dataStore: dataStore))
    }
}

// MARK: - VersionOneUUIDGenerator

final class VersionOneUUIDGenerator {
    private let clockSequenceService: ClockSequenceService
    private let dateService: any DateService
    private let nodeService: any NodeService
    private let randomNumberGenerator: any RandomNumberGenerator

    fileprivate convenience init(dataStore: DataStoreType) {
        self.init(
            clockSequenceService: .shared,
            dateService: .default,
            nodeService: DefaultNodeService(dataStore: dataStore),
            randomNumberGenerator: .default,
        )
    }

    init(
        clockSequenceService: ClockSequenceService,
        dateService: any DateService,
        nodeService: any NodeService,
        randomNumberGenerator: any RandomNumberGenerator
    ) {
        self.dateService = dateService
        self.nodeService = nodeService
        self.randomNumberGenerator = randomNumberGenerator
        self.clockSequenceService = clockSequenceService
    }
}

// MARK: UUIDGenerator

extension VersionOneUUIDGenerator: UUIDGenerator {
    func new() -> UUID {
        // UUID epoch offset (1582-10-15 → 1970-01-01) in 100ns units
        let uuidEpoch: UInt64 = 0x01_B2_1D_D2_13_81_40_00

        let now = dateService.now().timeIntervalSince1970
        let timestamp = UInt64(now * 10_000_000) + uuidEpoch

        // Handle clock rollback
        let clockSequence = clockSequenceService.getClockSequence(timestamp: timestamp)

        let timeLow = UInt32(timestamp & 0xFF_FF_FF_FF)
        let timeMid = UInt16((timestamp >> 32) & 0xFFFF)
        var timeHi = UInt16((timestamp >> 48) & 0x0FFF)
        // Version 1
        timeHi |= 0x1000

        var clockSeqHi = UInt8((clockSequence >> 8) & 0x3F)

        // Variant
        clockSeqHi |= randomNumberGenerator.variant

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
