// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

// MARK: - UserDefaultsDataStore

final class InMemoryDataStore: DataStore {
    static let shared = InMemoryDataStore()

    private let lock = NSLock()
    private var _randomNode: WrappedRandomNodeValue?
    var randomNode: WrappedRandomNodeValue? {
        get { lock.withLock { _randomNode } }
        set { lock.withLock { _randomNode = newValue } }
    }
}

// MARK: Equatable

extension InMemoryDataStore: Equatable {
    static func == (lhs: InMemoryDataStore, rhs: InMemoryDataStore) -> Bool {
        lhs.randomNode == rhs.randomNode
    }
}

// MARK: Hashable

extension InMemoryDataStore: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(randomNode)
    }
}

// MARK: Sendable

// Not using `Synchronization` so we can keep the minimum OS versions as low as possible.
extension InMemoryDataStore: @unchecked Sendable {}
