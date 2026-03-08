// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#elseif canImport(Foundation)
    public import Foundation
#else
    #error("SwiftUUID requires Foundation or FoundationEssentials")
#endif

extension UUID {
    /// Creates a UUID of the specified version.
    public init<Generator>(version: UUIDVersion<Generator>) {
        self = version.generator.new()
    }
}
