// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

extension UInt8 {
    func settingLeastSignificantBitOfFirstOctetToOne() -> UInt8 {
        var value = self
        value |= 0x01
        return value
    }
}
