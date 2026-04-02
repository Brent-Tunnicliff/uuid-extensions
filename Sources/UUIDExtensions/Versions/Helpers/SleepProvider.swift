// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

protocol SleepProvider: Sendable {
    func `for`(_ timeInterval: TimeInterval)
}

extension SleepProvider where Self == DefaultSleepProvider {
    static var `default`: Self {
        DefaultSleepProvider()
    }
}

struct DefaultSleepProvider: SleepProvider {
    func `for`(_ timeInterval: TimeInterval) {
        #if os(WASI)
            withLockFor(timeInterval)
        #else
            Thread.sleep(forTimeInterval: timeInterval)
        #endif
    }

    /// Hack to sleep by using a lock that never gets released.
    ///
    /// We call the lock with a date timeout of when we want to continue.
    /// This is only used when we cannot just use `Thread.sleep(forTimeInterval:)`.
    /// SInce it is risky and usually only accessed via the `#if os(WASI)` condition, I made it internal so we can specifically test it.
    func withLockFor(_ timeInterval: TimeInterval) {
        let lock = NSLock()
        lock.lock()
        // with this second lock call it will not continue until the time limit.
        lock.lock(before: Date().addingTimeInterval(timeInterval))
    }
}
