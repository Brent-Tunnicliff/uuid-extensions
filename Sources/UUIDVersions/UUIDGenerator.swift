// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(Foundation)
    public import Foundation
#endif

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#endif

// MARK: - UUIDGenerator

/// Generator of UUIDs.
public protocol UUIDGenerator: Identifiable, Sendable where ID == ObjectIdentifier {
    /// Creates a new instance of UUID.
    func new() -> UUID
}

// MARK: - AnyUUIDGenerator

/// Type erased UUIDGenerator to avoid needing complicated generics.
public struct AnyUUIDGenerator {
    private let wrappedId: @Sendable () -> ID
    private let wrappedNew: @Sendable () -> UUID

    init(wrapped: any UUIDGenerator) {
        self.wrappedId = { wrapped.id }
        self.wrappedNew = { wrapped.new() }
    }
}

// MARK: AnyUUIDGenerator

extension AnyUUIDGenerator: UUIDGenerator {
    /// Returns the id of the wrapped generator.
    public var id: ID {
        wrappedId()
    }

    /// Creates a new UUID from the wrapped generator.
    public func new() -> UUID {
        wrappedNew()
    }
}

// MARK: Equatable

extension AnyUUIDGenerator: Equatable {
    /// Compares if the ids of the wrapped generators match.
    public static func == (lhs: AnyUUIDGenerator, rhs: AnyUUIDGenerator) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: Hashable

extension AnyUUIDGenerator: Hashable {
    /// Hashes the id of the wrapped generator.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
