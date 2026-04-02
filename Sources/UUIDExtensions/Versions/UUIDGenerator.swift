// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#else
    public import Foundation
#endif

/// Generator of UUIDs.
public protocol UUIDGenerator: Hashable, Identifiable, Sendable where ID == Int {
    /// Creates a new instance of UUID.
    func new() -> UUID
}
