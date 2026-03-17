// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import Foundation

extension UUID {
    /// Max UUID has all 128 bits set to 1.
    ///
    /// It is the maximum uuid value of "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF"
    ///
    /// <https://www.rfc-editor.org/rfc/rfc9562#section-5.10>.
    public static let max = UUID(
        uuid: (
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff
        )
    )
}
