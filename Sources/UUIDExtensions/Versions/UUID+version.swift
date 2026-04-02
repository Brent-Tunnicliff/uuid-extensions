// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#else
    public import Foundation
#endif

extension UUID {
    /// Creates a UUID of the specified version.
    public init(version: UUIDVersion) {
        self = version.generator.new()
    }
}
