// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing
@testable import UUIDVersions

#if canImport(FoundationEssentials)
    import FoundationEssentials
#elseif canImport(Foundation)
    import Foundation
#else
    #error("SwiftUUID requires Foundation or FoundationEssentials")
#endif

struct UUIDVersionTests {
    typealias UUIDVersion = UUIDVersions.UUIDVersion<MockUUIDGenerator>
    private let mockUUIDGenerator = MockUUIDGenerator()

    @Test(arguments: UUIDVersion.Value.allCases)
    func idMapsToValue(_ argument: UUIDVersion.Value) {
        let version = UUIDVersion(value: argument, generator: mockUUIDGenerator)
        #expect(version.id == argument.rawValue)
    }
}

extension UUIDVersionTests {
    struct MockUUIDGenerator: UUIDGenerator {
        func new() -> UUID {
            preconditionFailure("Not implemented")
        }
    }
}
