// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import Foundation

extension UUID {
    /// Nil UUID has all 128 bits set to 0.
    ///
    /// It is the uuid value of "00000000-0000-0000-0000-000000000000"
    ///
    /// <https://www.rfc-editor.org/rfc/rfc9562#section-5.9>
    public static let `nil` = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
}
