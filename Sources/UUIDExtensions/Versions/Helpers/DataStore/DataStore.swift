// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

protocol DataStore: Sendable {
    var randomNode: WrappedRandomNodeValue? { get nonmutating set }
}
