// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
@testable import UUIDExtensions

final class MockRandomNumberGenerator: RandomNumberGenerator, @unchecked Sendable {
    private let lock = NSLock()

    private var _clockSequence: UInt16
    var clockSequence: UInt16 {
        get { lock.withLock { _clockSequence } }
        set { lock.withLock { _clockSequence = newValue } }
    }

    private var _int48: UInt64
    var int48: UInt64 {
        get { lock.withLock { _int48 } }
        set { lock.withLock { _int48 = newValue } }
    }

    private var _variant: UInt8
    var variant: UInt8 {
        get { lock.withLock { _variant } }
        set { lock.withLock { _variant = newValue } }
    }

    init(
        clockSequence: UInt16 = 0,
        int48: UInt64 = 0,
        variant: UInt8 = 0
    ) {
        self._clockSequence = clockSequence
        self._int48 = int48
        self._variant = variant
    }
}
