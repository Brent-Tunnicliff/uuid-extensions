// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import Foundation

/// Generator of UUIDs.
public protocol UUIDGenerator: Identifiable, Sendable where ID == ObjectIdentifier {
    /// Creates a new instance of UUID.
    func new() -> UUID
}
