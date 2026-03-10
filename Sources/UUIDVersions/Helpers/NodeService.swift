// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// Provides the node section bytes for some UUID versions.
protocol NodeService: Sendable {
    /// Returns a randomly generated node if the MAC Address is not available.
    ///
    /// This value is persisted to disk.
    var node: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) { get }
}

extension NodeService where Self == DefaultNodeService {
    static var `default`: Self { .shared }
}

struct DefaultNodeService: NodeService {
    static let shared = DefaultNodeService()

    // We should use the MAC Address and only fallback to random if there is none.
    // Technically we could get the MAC Address for macOS (and maybe linux?),
    // but given the complexity lets just do random for all platforms.
    var node: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) {
        getRandomNode()
    }

    private let dataStore: any DataStore
    private let randomNumberGenerator: any RandomNumberGenerator

    private init() {
        self.init(
            dataStore: .default,
            randomNumberGenerator: .default
        )
    }

    init(
        dataStore: any DataStore,
        randomNumberGenerator: any RandomNumberGenerator
    ) {
        self.dataStore = dataStore
        self.randomNumberGenerator = randomNumberGenerator
    }

    private func getRandomNode() -> (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) {
        if let cachedRandomNode = dataStore.randomNode {
            return cachedRandomNode
        }

        let node = randomNumberGenerator.int48
        let newRandomNode = (
            // Section [6.10](https://www.rfc-editor.org/rfc/rfc9562#unidentifiable) of rRFC9562
            // says we "MUST set the least significant bit of the first octet of the Node ID to 1".
            generateByte(node: node, index: 0).settingLeastSignificantBitOfFirstOctetToOne(),
            generateByte(node: node, index: 1),
            generateByte(node: node, index: 2),
            generateByte(node: node, index: 3),
            generateByte(node: node, index: 4),
            generateByte(node: node, index: 5)
        )

        dataStore.randomNode = newRandomNode
        return newRandomNode
    }

    private func generateByte(node: UInt64, index: Int) -> UInt8 {
        UInt8((node >> (8 * (5 - index))) & 0xFF)
    }
}
