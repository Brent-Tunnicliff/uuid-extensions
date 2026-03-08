// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

// MARK: - UUIDVersion

/// The [RFC 9562](https://www.rfc-editor.org/rfc/rfc9562) version to use for generating UUID values.
public struct UUIDVersion<Generator> where Generator: UUIDGenerator {
    let value: Value
    let generator: Generator
}

// MARK: Codable

extension UUIDVersion: Codable {}

// MARK: Hashable

extension UUIDVersion: Hashable {}

// MARK: Identifiable

extension UUIDVersion: Identifiable {
    /// Unique identifier of version.
    public var id: Int {
        value.rawValue
    }
}

// MARK: Sendable

extension UUIDVersion: Sendable {}

// MARK: - Value

extension UUIDVersion {
    enum Value: Int {
        case v4 = 4
    }
}

// MARK: CaseIterable

extension UUIDVersion.Value: CaseIterable {}

// MARK: Codable

extension UUIDVersion.Value: Codable {}

// MARK: Hashable

extension UUIDVersion.Value: Hashable {}

// MARK: Sendable

extension UUIDVersion.Value: Sendable {}
