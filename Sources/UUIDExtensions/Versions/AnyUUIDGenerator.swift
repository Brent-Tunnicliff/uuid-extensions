// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import Foundation

/// Type erased UUIDGenerator.
public struct AnyUUIDGenerator {
    private let wrapped: any UUIDGenerator

    init(wrapped: any UUIDGenerator) {
        self.wrapped = wrapped
    }
}

// MARK: AnyUUIDGenerator

extension AnyUUIDGenerator: UUIDGenerator {
    /// Returns the id of the wrapped generator.
    public var id: ID {
        wrapped.id
    }

    /// Creates a new UUID from the wrapped generator.
    public func new() -> UUID {
        wrapped.new()
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
