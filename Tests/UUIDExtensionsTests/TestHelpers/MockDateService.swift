// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
@testable import UUIDExtensions

struct MockDateService: DateService {
    private let store = DateValueStore()

    var nowValue: Date {
        get { store.value }
        nonmutating set { store.value = newValue }
    }

    func now() -> Date {
        nowValue
    }
}

extension MockDateService {
    private final class DateValueStore: @unchecked Sendable, Hashable {
        private let lock = NSLock()

        var _value: Date
        var value: Date {
            get { lock.withLock { _value } }
            set { lock.withLock { _value = newValue } }
        }

        init() {
            // Example date from [Appendix A. Test Vectors](https://www.rfc-editor.org/rfc/rfc9562#name-test-vectors).
            let exampleDate = "2022-02-22T19:22:22Z"
            guard let date = ISO8601DateFormatter().date(from: exampleDate) else {
                preconditionFailure("Unable to convert to date: \(exampleDate)")
            }

            self._value = date
        }

        static func == (lhs: MockDateService.DateValueStore, rhs: MockDateService.DateValueStore) -> Bool {
            lhs.value == rhs.value
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(value)
        }
    }
}
