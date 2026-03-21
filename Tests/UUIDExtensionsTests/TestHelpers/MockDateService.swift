// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
@testable import UUIDExtensions

final class MockDateService: DateService, @unchecked Sendable {
    private let lock = NSLock()

    private var _nowValue: Date
    var nowValue: Date {
        get { lock.withLock { _nowValue } }
        set { lock.withLock { _nowValue = newValue } }
    }

    func now() -> Date {
        nowValue
    }

    init() {
        // Example date from [Appendix A. Test Vectors](https://www.rfc-editor.org/rfc/rfc9562#name-test-vectors).
        let exampleDate = "2022-02-22T19:22:22Z"
        guard let date = ISO8601DateFormatter().date(from: exampleDate) else {
            preconditionFailure("Unable to convert to date: \(exampleDate)")
        }

        self._nowValue = date
    }
}
