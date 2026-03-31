// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

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

    /// Hack to sleep by using a condition lock that never gets it's condition.
    ///
    /// We call the lock with a date timeout of when we want to continue.
    /// This is only used when we cannot just use `Thread.sleep(forTimeInterval:)`.
    func withLockFor(_ timeInterval: TimeInterval) {
        let lock = NSConditionLock(condition: 1)
        lock.lock(before: Date().addingTimeInterval(timeInterval))
    }
}
