// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// Wrapper of the random node so it can easy conform to types like Codable and Hashable.
struct WrappedRandomNodeValue {
    let index0: UInt8
    let index1: UInt8
    let index2: UInt8
    let index3: UInt8
    let index4: UInt8
    let index5: UInt8

    var unwrapped: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) {
        (index0, index1, index2, index3, index4, index5)
    }

    init?(_ value: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)?) {
        guard let value else {
            return nil
        }

        self.index0 = value.0
        self.index1 = value.1
        self.index2 = value.2
        self.index3 = value.3
        self.index4 = value.4
        self.index5 = value.5
    }
}

// MARK: - Codable

extension WrappedRandomNodeValue: Codable {}

// MARK: - Hashable

extension WrappedRandomNodeValue: Hashable {}

// MARK: - Sendable

extension WrappedRandomNodeValue: Sendable {}
