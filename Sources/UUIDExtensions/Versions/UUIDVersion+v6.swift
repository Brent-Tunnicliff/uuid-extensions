// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

// MARK: - UUIDVersion

extension UUIDVersion {
    /// [UUID version 6](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-6).
    ///
    /// Similar to ``v1``, but reordered the leading timestamp for improved DB locality.
    /// Also we are following the recommendation to use a new random node and clock sequence for each UUID generated.
    ///
    /// - Warning: Recommended to use ``v7`` if possible.
    public static var v6: UUIDVersion {
        UUIDVersion(generator: VersionSixUUIDGenerator())
    }
}

// MARK: - VersionOneUUIDGenerator

struct VersionSixUUIDGenerator {
    let id = 6
    private let dateService: any DateService
    private let nodeService: any NodeService
    private let randomNumberGenerator: any RandomNumberGenerator

    fileprivate init() {
        self.init(
            dateService: .default,
            nodeService: DefaultNodeService(dataStore: nil),
            randomNumberGenerator: .default,
        )
    }

    init(
        dateService: any DateService,
        nodeService: any NodeService,
        randomNumberGenerator: any RandomNumberGenerator
    ) {
        self.dateService = dateService
        self.nodeService = nodeService
        self.randomNumberGenerator = randomNumberGenerator
    }
}

// MARK: - Equatable

extension VersionSixUUIDGenerator: Equatable {
    static func == (lhs: VersionSixUUIDGenerator, rhs: VersionSixUUIDGenerator) -> Bool {
        // Only public access is via the `static var v6`, so should alway be the same value.
        true
    }
}

// MARK: - Hashable

extension VersionSixUUIDGenerator: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: UUIDGenerator

extension VersionSixUUIDGenerator: UUIDGenerator {
    func new() -> UUID {
        // UUID epoch offset (1582-10-15 → 1970-01-01) in 100ns units
        let uuidEpoch: UInt64 = 0x01_B2_1D_D2_13_81_40_00

        let now = dateService.now().timeIntervalSince1970
        let timestamp = UInt64(now * 10_000_000) + uuidEpoch

        // Recommended to use a new random clock sequence each time.
        let clockSequence = randomNumberGenerator.clockSequence

        let timeHigh = UInt32((timestamp >> 28) & 0xFF_FF_FF_FF)
        let timeMid = UInt16((timestamp >> 12) & 0xFFFF)
        var timeLow = UInt16(timestamp & 0x0FFF)

        // Version 6
        timeLow |= 0x6000

        var clockSeqHi = UInt8((clockSequence >> 8) & 0x3F)

        // Variant
        clockSeqHi = (clockSeqHi & 0x3F) | 0x80

        let clockSeqLow = UInt8(clockSequence & 0xFF)
        let node = nodeService.node

        return UUID(
            uuid: (
                // time_high
                UInt8((timeHigh >> 24) & 0xFF),
                UInt8((timeHigh >> 16) & 0xFF),
                UInt8((timeHigh >> 8) & 0xFF),
                UInt8(timeHigh & 0xFF),

                // time_mid
                UInt8((timeMid >> 8) & 0xFF),
                UInt8(timeMid & 0xFF),

                // ver & time_low
                UInt8((timeLow >> 8) & 0xFF),
                UInt8(timeLow & 0xFF),

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
