// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#elseif canImport(Foundation)
    public import Foundation
#else
    #error("SwiftUUID requires Foundation or FoundationEssentials")
#endif

/// Used for generating [UUID version 4](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-4).
public struct VersionFourUUIDGenerator: UUIDGenerator {
    /// Generated a new UUID of version 4.
    ///
    /// This is just wrapping the default UUID creation as Foundation uses that by default.
    ///
    /// - Warning: Technically this uses RFC 4122 and we are following the later RFC 9562 for the other versions.
    public func new() -> UUID {
        UUID()
    }
}

extension UUIDVersion where Generator == VersionFourUUIDGenerator {
    /// [UUID version 4](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-4).
    public static let v4 = UUIDVersion(value: .v4, generator: VersionFourUUIDGenerator())
}
