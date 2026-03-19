// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import Foundation

extension UUID {
    /// Creates a UUID of the specified version.
    public init(version: UUIDVersion) {
        self = version.generator.new()
    }
}
