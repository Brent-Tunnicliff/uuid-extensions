// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

enum Sleep {
    static func `for`(_ timeInterval: TimeInterval) {
        #if os(WASI)
            // This is a really bad way to do this, but WASI does not appear to have access to other nicer ways.
            // We only expect this to call for very rare edge cases and only for a millisecond at most.
            let end = Date().addingTimeInterval(timeInterval)
            while Date() < end {}
        #else
            Thread.sleep(forTimeInterval: timeInterval)
        #endif
    }
}
