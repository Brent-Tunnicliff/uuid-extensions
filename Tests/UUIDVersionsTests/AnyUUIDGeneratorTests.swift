// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import UUIDVersions

struct AnyUUIDGeneratorTests {
    private let wrappedGenerator = MockUUIDGenerator()
    private let anyGenerator: AnyUUIDGenerator

    init() {
        self.anyGenerator = AnyUUIDGenerator(wrapped: wrappedGenerator)
    }

    @Test
    func idReturnsWrappedID() {
        #expect(anyGenerator.id == wrappedGenerator.id)
    }

    @Test
    func newReturnsWrappedUUID() {
        #expect(anyGenerator.new() == wrappedGenerator.uuidValue)
    }

    @Test
    func equalsIfBothWrapTheSame() {
        let otherGenerator = AnyUUIDGenerator(wrapped: wrappedGenerator)
        #expect(anyGenerator == otherGenerator)
    }

    @Test
    func notEqualsIfWrappedDifferent() {
        let otherWrappedGenerator = MockUUIDGenerator()
        let otherGenerator = AnyUUIDGenerator(wrapped: otherWrappedGenerator)
        #expect(anyGenerator != otherGenerator)
    }

    @Test
    func hashSameIfWrappedSame() {
        let otherGenerator = AnyUUIDGenerator(wrapped: wrappedGenerator)
        #expect(anyGenerator.hashValue == otherGenerator.hashValue)
    }

    @Test
    func hashDifferentIfWrappedDifferent() {
        let otherWrappedGenerator = MockUUIDGenerator()
        let otherGenerator = AnyUUIDGenerator(wrapped: otherWrappedGenerator)
        #expect(anyGenerator.hashValue != otherGenerator.hashValue)
    }
}

extension AnyUUIDGeneratorTests {
    final class MockUUIDGenerator: UUIDGenerator {
        // Always return the same state so we can compare.
        let uuidValue = UUID()

        func new() -> UUID {
            uuidValue
        }
    }
}
