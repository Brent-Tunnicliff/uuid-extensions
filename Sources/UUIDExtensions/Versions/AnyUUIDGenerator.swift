// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import Foundation

/// Type erased UUIDGenerator.
public struct AnyUUIDGenerator {
    private let wrapped: any UUIDGenerator
    private let isEqual: @Sendable (AnyUUIDGenerator) -> Bool

    init<Wrapped>(wrapped: Wrapped) where Wrapped: UUIDGenerator {
        self.wrapped = wrapped
        self.isEqual = { other in
            guard let otherWrapped = other.wrapped as? Wrapped else {
                return false
            }

            return wrapped == otherWrapped
        }
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
        lhs.isEqual(rhs)
    }
}

// MARK: Hashable

extension AnyUUIDGenerator: Hashable {
    /// Hashes the id of the wrapped generator.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrapped)
    }
}
