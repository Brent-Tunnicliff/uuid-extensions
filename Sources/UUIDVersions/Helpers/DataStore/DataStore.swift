// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

protocol DataStore: Hashable, Sendable {
    var randomNode: WrappedRandomNodeValue? { get nonmutating set }
}
