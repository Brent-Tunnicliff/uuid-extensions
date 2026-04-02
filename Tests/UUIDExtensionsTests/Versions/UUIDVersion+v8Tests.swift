// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Crypto
import Testing
@testable import UUIDExtensions

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

@Suite("UUIDVersion+v8Tests")
struct UUIDVersionV8Tests {
    // https://www.rfc-editor.org/rfc/rfc9562#name-example-of-a-uuidv8-value-t
    @Test
    func matchesTheTimeBasedExample() throws {
        // Using the hardcoded values stated in the example table.
        let generator = VersionEightUUIDGenerator(
            uuid: (
                // custom_a
                UInt8(0x24),
                UInt8(0x89),
                UInt8(0xE9),
                UInt8(0xAD),
                UInt8(0x2E),
                UInt8(0xE2),

                // custom_b
                UInt8(0x0E),
                UInt8(0x00),

                // custom_c
                UInt8(0x0E),
                UInt8(0xC9),
                UInt8(0x32),
                UInt8(0xD5),
                UInt8(0xF6),
                UInt8(0x91),
                UInt8(0x81),
                UInt8(0xC0)
            )
        )

        #expect(generator.new().uuidString == "2489E9AD-2EE2-8E00-8EC9-32D5F69181C0")
    }

    // https://www.rfc-editor.org/rfc/rfc9562#name-example-of-a-uuidv8-value-n
    @Test
    func matchesTheNameBasedExample() {
        let namespace = UUID.dns
        let name = "www.example.com"

        var namespaceID = namespace.uuid
        var data = withUnsafeBytes(of: &namespaceID) { Data($0) }
        data.append(contentsOf: name.utf8)

        // Hash with SHA-256
        let digest = SHA256.hash(data: data)
        let generator = VersionEightUUIDGenerator(data: Data(digest))

        #expect(generator.new().uuidString.lowercased() == "5c146b14-3c52-8afd-938a-375d0df1fbf6")
    }

    @Test
    func padsValueIfDataSmall() throws {
        let data = try #require("hello".data(using: .utf8))
        let generator = VersionEightUUIDGenerator(data: data)
        #expect(generator.new().uuidString == "68656C6C-6F00-8000-8000-000000000000")
    }
}
