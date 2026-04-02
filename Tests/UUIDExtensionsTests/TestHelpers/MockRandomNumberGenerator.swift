// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

@testable import UUIDExtensions

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

final class MockRandomNumberGenerator: RandomNumberGenerator, @unchecked Sendable {
    private let lock = NSLock()

    private var _bytesValue: [UInt8]
    var bytesValue: [UInt8] {
        get { lock.withLock { _bytesValue } }
        set { lock.withLock { _bytesValue = newValue } }
    }

    private var singleByteValues: [UInt8]
    var byte: UInt8 {
        lock.withLock { singleByteValues.removeFirst() }
    }

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

    init(
        bytesValue: [UInt8] = [0],
        clockSequence: UInt16 = 0,
        int48: UInt64 = 0,
        ofSizeUInt16: [UInt16] = [0],
        singleByteValues: [UInt8] = [0]
    ) {
        self._bytesValue = bytesValue
        self._clockSequence = clockSequence
        self._int48 = int48
        self.ofSizeUInt16 = ofSizeUInt16
        self.singleByteValues = singleByteValues
    }

    func bytes(size: Int) -> [UInt8] {
        lock.withLock {
            (0..<size).map { _ in
                _bytesValue.removeFirst()
            }
        }
    }

    private var ofSizeUInt16: [UInt16]
    func of(size: UInt16) -> UInt16 {
        lock.withLock { ofSizeUInt16.removeFirst() }
    }
}
