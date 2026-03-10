// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(Foundation)
    public import Foundation
#endif

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#endif

extension UUID {
    /// Creates a UUID of the specified version.
    public init(version: UUIDVersion) {
        self = version.generator.new()
    }
}
