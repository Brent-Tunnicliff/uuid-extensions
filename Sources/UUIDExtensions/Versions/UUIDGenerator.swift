// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import Foundation

/// Generator of UUIDs.
public protocol UUIDGenerator: Hashable, Identifiable, Sendable where ID == Int {
    /// Creates a new instance of UUID.
    func new() -> UUID
}
