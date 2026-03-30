// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

// MARK: - UUIDVersion

extension UUIDVersion {
    /// [UUID version 2](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-2).
    ///
    /// Very similar to ``v1``, but embeds the domain and local id for linking to the creator
    /// if that level of audibility is needed.
    ///
    /// - Parameters:
    ///    - dataStore: The type of data store to be used when generating the node for the UUID.
    ///    - domain: Represents the domain that the `localID` belongs to.
    ///    - localID: Represents the unique entity within the `domain`.
    /// - Returns: ``UUIDVersion`` configured as `v2` and containing the input dataStore.
    ///
    /// - Warning: The domain and localID use up large chunks of the final value,
    ///   so it increases the risk of collisions compared to `v1`.
    public static func v2(
        dataStore: DataStoreType = .persistent,
        domain: UInt8,
        localID: UInt32
    ) -> UUIDVersion {
        UUIDVersion(
            generator: VersionTwoUUIDGenerator(
                dataStore: dataStore,
                domain: domain,
                localID: localID
            )
        )
    }
}

// MARK: - VersionTwoUUIDGenerator

struct VersionTwoUUIDGenerator {
    let id = 2
    private let clockSequenceService: ClockSequenceService
    private let dateService: any DateService
    private let dataStoreType: DataStoreType
    private let domain: UInt8
    private let localID: UInt32
    private let nodeService: any NodeService
    private let randomNumberGenerator: any RandomNumberGenerator

    fileprivate init(
        dataStore: DataStoreType,
        domain: UInt8,
        localID: UInt32
    ) {
        self.init(
            clockSequenceService: .shared,
            dateService: .default,
            dataStoreType: dataStore,
            domain: domain,
            localID: localID,
            nodeService: DefaultNodeService(dataStore: dataStore),
            randomNumberGenerator: .default
        )
    }

    init(
        clockSequenceService: ClockSequenceService,
        dateService: any DateService,
        dataStoreType: DataStoreType,
        domain: UInt8,
        localID: UInt32,
        nodeService: any NodeService,
        randomNumberGenerator: any RandomNumberGenerator
    ) {
        self.clockSequenceService = clockSequenceService
        self.dateService = dateService
        self.dataStoreType = dataStoreType
        self.domain = domain
        self.localID = localID
        self.nodeService = nodeService
        self.randomNumberGenerator = randomNumberGenerator
    }
}

// MARK: - Equatable

extension VersionTwoUUIDGenerator: Equatable {
    static func == (lhs: VersionTwoUUIDGenerator, rhs: VersionTwoUUIDGenerator) -> Bool {
        lhs.domain == rhs.domain
            && lhs.localID == rhs.localID
            && lhs.dataStoreType == rhs.dataStoreType
    }
}

// MARK: - Hashable

extension VersionTwoUUIDGenerator: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(dataStoreType)
        hasher.combine(domain)
        hasher.combine(id)
        hasher.combine(localID)
    }
}

// MARK: UUIDGenerator

extension VersionTwoUUIDGenerator: UUIDGenerator {
    func new() -> UUID {
        // UUID epoch offset (1582-10-15 → 1970-01-01) in 100ns units
        let uuidEpoch: UInt64 = 0x01_B2_1D_D2_13_81_40_00

        let now = dateService.now().timeIntervalSince1970
        let timestamp = UInt64(now * 10_000_000) + uuidEpoch

        // Handle clock rollback
        let clockSequence = clockSequenceService.getClockSequence(
            timestamp: timestamp,
            // The default increment does not show up since clock sequence only occupies one digit in the final id.
            clockSequenceIncrement: 0x0100
        )

        let timeMid = UInt16((timestamp >> 32) & 0xFFFF)
        var timeHi = UInt16((timestamp >> 48) & 0x0FFF)
        // Version 2
        timeHi |= 0x2000

        var clockSeqHi = UInt8((clockSequence >> 8) & 0x3F)

        // Variant
        clockSeqHi = (clockSeqHi & 0x3F) | 0x80

        let node = nodeService.node

        return UUID(
            uuid: (
                // local identifier
                UInt8((localID >> 24) & 0xFF),
                UInt8((localID >> 16) & 0xFF),
                UInt8((localID >> 8) & 0xFF),
                UInt8(localID & 0xFF),

                // time_mid
                UInt8((timeMid >> 8) & 0xFF),
                UInt8(timeMid & 0xFF),

                // ver & time_high
                UInt8((timeHi >> 8) & 0xFF),
                UInt8(timeHi & 0xFF),

                // var & clock_seq
                clockSeqHi,
                domain,

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
