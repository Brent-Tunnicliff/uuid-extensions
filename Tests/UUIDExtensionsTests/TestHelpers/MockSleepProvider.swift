// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

@testable import UUIDExtensions

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

final class MockSleepProvider: SleepProvider, @unchecked Sendable {
    private let lock = NSLock()

    private var _forHandler: (TimeInterval) -> Void = { _ in }
    var forHandler: (TimeInterval) -> Void {
        get { lock.withLock { _forHandler } }
        set { lock.withLock { _forHandler = newValue } }
    }

    func `for`(_ timeInterval: TimeInterval) {
        forHandler(timeInterval)
    }
}
