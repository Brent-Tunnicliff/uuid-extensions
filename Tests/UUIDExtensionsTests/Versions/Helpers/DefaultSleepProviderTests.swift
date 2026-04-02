// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing
@testable import UUIDExtensions

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

struct DefaultSleepProviderTests {
    let sleepTime: TimeInterval = 0.1
    let sleepProvider = DefaultSleepProvider()

    @Test
    @available(iOS 16.0, *)
    @available(tvOS 16.0, *)
    @available(watchOS 9.0, *)
    func `for`() async throws {
        try await withThrowingTaskGroup { group in
            group.addTask {
                try await Task.sleep(for: .seconds(1))
                throw TimeoutError()
            }

            group.addTask {
                sleepProvider.for(sleepTime)
            }

            // Await for the first group to return, if it is the timeout then it will throw.
            try await group.first(where: { _ in true })
            group.cancelAll()
        }
    }

    @Test
    @available(iOS 16.0, *)
    @available(tvOS 16.0, *)
    @available(watchOS 9.0, *)
    func withLockFor() async throws {
        try await withThrowingTaskGroup { group in
            group.addTask {
                try await Task.sleep(for: .seconds(1))
                throw TimeoutError()
            }

            group.addTask {
                sleepProvider.withLockFor(sleepTime)
            }

            // Await for the first group to return, if it is the timeout then it will throw.
            try await group.first(where: { _ in true })
            group.cancelAll()
        }
    }
}
