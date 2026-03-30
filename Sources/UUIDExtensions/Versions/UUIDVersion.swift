// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// The [RFC 9562](https://www.rfc-editor.org/rfc/rfc9562) version to use for generating UUID values.
public struct UUIDVersion {
    let generator: AnyUUIDGenerator

    init(generator: any UUIDGenerator) {
        self.generator = AnyUUIDGenerator(wrapped: generator)
    }
}

// MARK: Hashable

extension UUIDVersion: Hashable {}

// MARK: Sendable

extension UUIDVersion: Sendable {}
