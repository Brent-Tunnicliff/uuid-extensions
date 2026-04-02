// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

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
