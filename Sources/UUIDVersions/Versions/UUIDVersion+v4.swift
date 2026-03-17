// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

// MARK: - UUIDVersion

extension UUIDVersion {
    /// [UUID version 4](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-4).
    public static let v4 = UUIDVersion(generator: VersionFourUUIDGenerator())
}

// MARK: - VersionFourUUIDGenerator

/// Used for generating [UUID version 4](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-4).
final class VersionFourUUIDGenerator {
    fileprivate init() {}
}

// MARK: UUIDGenerator

extension VersionFourUUIDGenerator: UUIDGenerator {
    /// Generated a new UUID of version 4.
    ///
    /// This is just wrapping the default UUID creation as Foundation uses that by default.
    ///
    /// - Warning: Technically this uses RFC 4122 and we are following the later RFC 9562 for the other versions.
    func new() -> UUID {
        UUID()
    }
}
