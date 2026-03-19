// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import UUIDExtensions

struct DefaultNodeServiceTests {
    private let dataStore = InMemoryDataStore()
    private let mockRandomNumberGenerator: MockRandomNumberGenerator
    private let nodeService: DefaultNodeService
    private let randomValue: UInt64 = 0x9E_6B_DE_CE_D8_46
    // We expect that the least significant bit of the first octet is set to a value of 1
    private let expectedNode = (0x9F, 0x6B, 0xDE, 0xCE, 0xD8, 0x46)

    init() {
        self.mockRandomNumberGenerator = MockRandomNumberGenerator(
            int48: randomValue,
            variant: 0xb0
        )
        self.nodeService = DefaultNodeService(
            dataStore: dataStore,
            randomNumberGenerator: mockRandomNumberGenerator
        )
    }

    @Test
    func getRandomNode() {
        let node = nodeService.node

        #expect(node.0 == expectedNode.0)
        #expect(node.1 == expectedNode.1)
        #expect(node.2 == expectedNode.2)
        #expect(node.3 == expectedNode.3)
        #expect(node.4 == expectedNode.4)
        #expect(node.5 == expectedNode.5)
    }

    @Test
    func nodeIsStored() throws {
        // Double check it is an empty store before running the test.
        #expect(dataStore.randomNode == nil)

        _ = nodeService.node

        let storedNode = try #require(dataStore.randomNode).unwrapped

        #expect(storedNode.0 == expectedNode.0)
        #expect(storedNode.1 == expectedNode.1)
        #expect(storedNode.2 == expectedNode.2)
        #expect(storedNode.3 == expectedNode.3)
        #expect(storedNode.4 == expectedNode.4)
        #expect(storedNode.5 == expectedNode.5)
    }

    @Test
    func nodeReturnsStored() throws {
        // Setting a value that is not returned by the random generator to make sure it is returned instead.
        let expectedCachedNode: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) = (0x01, 0x02, 0x03, 0x04, 0x05, 0x06)
        dataStore.randomNode = WrappedRandomNodeValue(expectedCachedNode)

        let node = nodeService.node

        #expect(node.0 == expectedCachedNode.0)
        #expect(node.1 == expectedCachedNode.1)
        #expect(node.2 == expectedCachedNode.2)
        #expect(node.3 == expectedCachedNode.3)
        #expect(node.4 == expectedCachedNode.4)
        #expect(node.5 == expectedCachedNode.5)
    }
}
