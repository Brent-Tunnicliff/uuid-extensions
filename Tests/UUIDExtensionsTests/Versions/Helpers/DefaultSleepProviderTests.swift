// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import UUIDExtensions

struct DefaultSleepProviderTests {
    let sleepTime: TimeInterval = 0.1
    let sleepProvider = DefaultSleepProvider()

    @Test
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
