// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

protocol DateService: Sendable {
    func now() -> Date
}

extension DateService where Self == SystemDateService {
    static var `default`: Self { .shared }
}

struct SystemDateService: DateService {
    static let shared = SystemDateService()

    private init() {}

    func now() -> Date {
        Date()
    }
}
