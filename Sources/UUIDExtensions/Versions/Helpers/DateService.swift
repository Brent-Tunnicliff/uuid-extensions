// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

protocol DateService: Sendable {
    func now() -> Date
}

extension DateService where Self == SystemDateService {
    static var `default`: Self {
        SystemDateService()
    }
}

struct SystemDateService: DateService {
    func now() -> Date {
        Date()
    }
}
