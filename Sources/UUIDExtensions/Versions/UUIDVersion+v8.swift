// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#else
    public import Foundation
#endif

// MARK: - UUIDVersion

extension UUIDVersion {
    /// [UUID version 8](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-8).
    ///
    /// Provides a format for experimental or vendor-specific use cases.
    /// This just wraps the input but sets the correct version and variant values.
    ///
    /// - Parameter uuid: The `uuid_t` value to wrap with the standard v8 version and variant.
    /// - Returns: ``UUIDVersion`` configured as `v8` based on the input configuration.
    /// - Warning: It is the consumers responsibility to make sure the implementation is unique to their need.
    public static func v8(uuid: uuid_t) -> UUIDVersion {
        UUIDVersion(generator: VersionEightUUIDGenerator(uuid: uuid))
    }

    /// [UUID version 8](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-8).
    ///
    /// Provides a format for experimental or vendor-specific use cases.
    /// This maps the input data directly into the UUID with the correct version and variant values.
    ///
    /// - Parameter data: The data to be converted into the UUID. We will take the leading 128 bits and pad with `0` if smaller than needed.
    /// - Returns: ``UUIDVersion`` configured as `v8` based on the input configuration.
    /// - Warning: It is the consumers responsibility to make sure the implementation is unique to their need.
    public static func v8(data: Data) -> UUIDVersion {
        UUIDVersion(generator: VersionEightUUIDGenerator(data: data))
    }
}

// MARK: - VersionEightUUIDGenerator

struct VersionEightUUIDGenerator {
    let id = 8
    let wrapped: [UInt8]

    init(uuid: uuid_t) {
        self.wrapped = [
            uuid.0,
            uuid.1,
            uuid.2,
            uuid.3,
            uuid.4,
            uuid.5,
            uuid.6,
            uuid.7,
            uuid.8,
            uuid.9,
            uuid.10,
            uuid.11,
            uuid.12,
            uuid.13,
            uuid.14,
            uuid.15,
        ]
    }

    init(data: Data) {
        var data = Array(data.prefix(16))

        while data.count < 16 {
            data.append(0)
        }

        self.wrapped = data
    }
}

// MARK: - Hashable

extension VersionEightUUIDGenerator: Hashable {}

// MARK: UUIDGenerator

extension VersionEightUUIDGenerator: UUIDGenerator {
    func new() -> UUID {
        var bytes = wrapped

        // Version 8
        bytes[6] = (bytes[6] & 0x0F) | 0x80

        // Variant
        bytes[8] = (bytes[8] & 0x3F) | 0x80

        return UUID(
            uuid: (
                bytes[0],
                bytes[1],
                bytes[2],
                bytes[3],
                bytes[4],
                bytes[5],
                bytes[6],
                bytes[7],
                bytes[8],
                bytes[9],
                bytes[10],
                bytes[11],
                bytes[12],
                bytes[13],
                bytes[14],
                bytes[15],
            )
        )
    }
}
