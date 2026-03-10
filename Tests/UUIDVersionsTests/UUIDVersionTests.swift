// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import UUIDVersions

struct UUIDVersionTests {
    typealias UUIDVersion = UUIDVersions.UUIDVersion
    private let mockUUIDGenerator = MockUUIDGenerator()

    @Test(arguments: UUIDVersion.Value.allCases)
    func idMapsToValue(_ argument: UUIDVersion.Value) {
        let version = UUIDVersion(argument, generator: mockUUIDGenerator)
        #expect(version.id == argument.rawValue)
    }
}

extension UUIDVersionTests {
    final class MockUUIDGenerator: UUIDGenerator {
        func new() -> UUID {
            preconditionFailure("Not implemented")
        }
    }
}
