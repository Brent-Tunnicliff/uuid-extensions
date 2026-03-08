// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#else
    public import Foundation
#endif

/// Generator of UUIDs.
public protocol UUIDGenerator: Codable, Hashable, Sendable {
    /// Creates a new instance of UUID.
    func new() -> UUID
}
