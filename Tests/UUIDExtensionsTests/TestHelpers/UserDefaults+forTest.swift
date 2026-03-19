// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation

extension UserDefaults {
    static func forTest(
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: Int = #line
    ) -> UserDefaults? {
        let suiteName = "\(fileID)_\(function)_\(line)_\(UUID().uuidString)"
            .addingPercentEncoding(withAllowedCharacters: .alphanumerics)

        return suiteName.map { UserDefaults(suiteName: $0) } ?? nil
    }

    /// Clears all data.
    func tearDown() {
        for key in dictionaryRepresentation().keys {
            removeObject(forKey: key)
        }
    }
}
