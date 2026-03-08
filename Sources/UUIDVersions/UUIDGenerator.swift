// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#elseif canImport(Foundation)
    public import Foundation
#else
    #error("SwiftUUID requires Foundation or FoundationEssentials")
#endif

/// Generator of UUIDs.
public protocol UUIDGenerator: Codable, Hashable, Sendable {
    /// Creates a new instance of UUID.
    func new() -> UUID
}
