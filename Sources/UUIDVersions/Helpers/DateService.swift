// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(Foundation)
    import Foundation
#endif

#if canImport(FoundationEssentials)
    import FoundationEssentials
#endif

protocol DateService: Hashable, Sendable {
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
