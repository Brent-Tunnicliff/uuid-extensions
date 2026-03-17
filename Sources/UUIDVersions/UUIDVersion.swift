// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

// MARK: - UUIDVersion

/// The [RFC 9562](https://www.rfc-editor.org/rfc/rfc9562) version to use for generating UUID values.
public struct UUIDVersion {
    let value: Value
    let generator: AnyUUIDGenerator

    init(_ value: Value, generator: any UUIDGenerator) {
        self.value = value
        self.generator = AnyUUIDGenerator(wrapped: generator)
    }
}

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
        case v1 = 1
        case v2 = 2
        case v4 = 4
    }
}

// MARK: CaseIterable

extension UUIDVersion.Value: CaseIterable {}

// MARK: Hashable

extension UUIDVersion.Value: Hashable {}

// MARK: Sendable

extension UUIDVersion.Value: Sendable {}
