// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import Testing
@testable import UUIDExtensions

@Suite("UUIDVersion+v7Tests")
struct UUIDVersionV7Tests {
    private let mockDateService = MockDateService()
    private let mockRandomNumberGenerator = MockRandomNumberGenerator(
        bytesValue: [
            0x0C,
            0xC3,
            0x08,
            0xC4,
            0xDC,
            0x0C,
            0x0C,
            0x07,
            0x39,
            0x8F,
        ],
        variant: 0x90
    )
    private let generator: VersionSevenUUIDGenerator

    init() {
        self.generator = VersionSevenUUIDGenerator(
            configuration: .default,
            dateService: mockDateService,
            randomNumberGenerator: mockRandomNumberGenerator,
            usleep: { _ in },
            state: VersionSevenUUIDGenerator.State(randomNumberGenerator: mockRandomNumberGenerator)
        )
    }

    // https://www.rfc-editor.org/rfc/rfc9562#name-example-of-a-uuidv6-value
    @Test
    func matchesTheStandardExample() {
        let uuid = generator.new().uuidString
        #expect(uuid == "017F22E2-79B0-7CC3-98C4-DC0C0C07398F")
    }

    @Test
    @available(iOS 16.0, *)
    @available(tvOS 16.0, *)
    @available(watchOS 9.0, *)
    func isValid() {
        for _ in 0..<1000 {
            let uuid = UUID(version: .v7).uuidString.lowercased()

            // With the version and variant position we expect one of the following formats:
            //  - xxxxxxxx-xxxx-7xxx-8xxx-xxxxxxxxxxxx
            //  - xxxxxxxx-xxxx-7xxx-9xxx-xxxxxxxxxxxx
            //  - xxxxxxxx-xxxx-7xxx-axxx-xxxxxxxxxxxx
            //  - xxxxxxxx-xxxx-7xxx-bxxx-xxxxxxxxxxxx
            let regex = /^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/

            #expect(
                uuid.wholeMatch(of: regex) != nil,
                "'\(uuid)' does not match the expected UUIDv7 regex pattern"
            )
        }
    }
}

@Suite("UUIDVersion+v7Tests")
struct UUIDVersionV7ConfigurationTests {
    private let mockDateService: MockDateService
    private let mockRandomNumberGenerator: MockRandomNumberGenerator

    init() throws {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = try #require(formatter.date(from: "2022-02-22T19:22:22.12345Z"))
        self.mockDateService = MockDateService(nowValue: date)
        self.mockRandomNumberGenerator = MockRandomNumberGenerator(
            // Adding all the bytes needed for any of the tests so each test doesn't need to set this up themselves.
            bytesValue: Array(0x00...0x2f),
            ofSizeUInt16: [0x0000, 0x0987],
            singleByteValues: [0x15, 0xac, 0x72],
            variant: 0x90
        )
    }

    @Test
    func withIncreasedClockPrecision() {
        let generator = VersionSevenUUIDGenerator(
            configuration: .withIncreasedClockPrecision,
            dateService: mockDateService,
            randomNumberGenerator: mockRandomNumberGenerator,
            usleep: { _ in },
            state: VersionSevenUUIDGenerator.State(randomNumberGenerator: mockRandomNumberGenerator)
        )

        #expect(generator.new().uuidString == "017F22E2-7A2B-73E7-9001-020304050607")
    }

    enum CounterArgument: CaseIterable {
        case fixedLength
        case increasedClockPrecisionAndFixedLength
        case increasedClockPrecisionAndMonotonicRandom
        case monotonicRandom

        var configuration: V7Configuration {
            switch self {
            case .fixedLength: .withFixedLengthCounter
            case .increasedClockPrecisionAndFixedLength: .withIncreasedClockPrecisionAndFixedLengthCounter
            case .increasedClockPrecisionAndMonotonicRandom: .withIncreasedClockPrecisionAndMonotonicRandomCounter
            case .monotonicRandom: .withMonotonicRandomCounter
            }
        }

        var expectedResults: (String, String, String, String, String) {
            switch self {
            case .fixedLength:
                (
                    "017F22E2-7A2B-7000-9001-020304050607",
                    "017F22E2-7A2B-7001-9809-0A0B0C0D0E0F",
                    "017F22E2-7A2B-7002-9011-121314151617",
                    "017F22E2-7A2B-7003-9819-1A1B1C1D1E1F",
                    "017F22E2-7E13-7987-9021-222324252627",
                )
            case .increasedClockPrecisionAndFixedLength:
                (
                    "017F22E2-7A2B-73E7-9000-000102030405",
                    "017F22E2-7A2B-73E7-9001-060708090A0B",
                    "017F22E2-7A2B-73E7-9002-0C0D0E0F1011",
                    "017F22E2-7A2B-73E7-9003-121314151617",
                    "017F22E2-7E13-73E7-9987-18191A1B1C1D",
                )
            case .increasedClockPrecisionAndMonotonicRandom:
                (
                    "017F22E2-7A2B-73E7-9001-020304050607",
                    "017F22E2-7A2B-73E7-9001-020304050715",
                    "017F22E2-7A2B-73E7-9001-0203040508AC",
                    "017F22E2-7A2B-73E7-9001-020304050972",
                    "017F22E2-7E13-73E7-9809-0A0B0C0D0E0F",
                )
            case .monotonicRandom:
                (
                    "017F22E2-7A2B-7001-9203-040506070809",
                    "017F22E2-7A2B-7001-9203-040506070915",
                    "017F22E2-7A2B-7001-9203-040506070AAC",
                    "017F22E2-7A2B-7001-9203-040506070B72",
                    "017F22E2-7E13-7A0B-9C0D-0E0F10111213",
                )
            }
        }

        var expectedSleepMicroseconds: UInt32 {
            switch self {
            case .fixedLength, .monotonicRandom:
                1000
            case .increasedClockPrecisionAndFixedLength, .increasedClockPrecisionAndMonotonicRandom:
                1
            }
        }
    }

    @Test(arguments: CounterArgument.allCases)
    @available(iOS 17, *)
    @available(tvOS 17, *)
    @available(watchOS 10, *)
    func counter(_ argument: CounterArgument) {
        let generator = VersionSevenUUIDGenerator(
            configuration: argument.configuration,
            dateService: mockDateService,
            randomNumberGenerator: mockRandomNumberGenerator,
            usleep: { _ in },
            state: VersionSevenUUIDGenerator.State(randomNumberGenerator: mockRandomNumberGenerator)
        )

        var currentValue = generator.new()
        var previousValue = currentValue

        #expect(currentValue.uuidString == argument.expectedResults.0)

        // Then the following calls with the same time stamp increment the counter then generate more random values.

        currentValue = generator.new()
        #expect(currentValue.uuidString == argument.expectedResults.1)
        #expect(previousValue < currentValue)
        previousValue = currentValue

        currentValue = generator.new()
        #expect(currentValue.uuidString == argument.expectedResults.2)
        #expect(previousValue < currentValue)
        previousValue = currentValue

        currentValue = generator.new()
        #expect(currentValue.uuidString == argument.expectedResults.3)
        #expect(previousValue < currentValue)
        previousValue = currentValue

        // New timestamp gets a new random counter value
        mockDateService.nowValue = mockDateService.nowValue.advanced(by: 1)

        currentValue = generator.new()
        #expect(currentValue.uuidString == argument.expectedResults.4)
        #expect(previousValue < currentValue)
    }

    @Test(arguments: CounterArgument.allCases)
    func counterWaitsForNextTimestampAtMaxValue(_ argument: CounterArgument) async {
        let sleepLength = await withCheckedContinuation { continuation in
            // Initially set all as max.
            let mockRandomNumberGenerator = MockRandomNumberGenerator(
                bytesValue: (0..<40).map { _ in UInt8.max },
                clockSequence: UInt16.max,
                int48: UInt64.max,
                ofSizeUInt16: (0..<40).map { _ in UInt16.max },
                singleByteValues: (0..<40).map { _ in UInt8.max },
                variant: UInt8.max
            )

            let generator = VersionSevenUUIDGenerator(
                configuration: argument.configuration,
                dateService: mockDateService,
                randomNumberGenerator: mockRandomNumberGenerator,
                usleep: {
                    // Make sure to increment the date to avoid this immediately getting called again.
                    // As the system will call to create a new UUID right after this "sleep".
                    mockDateService.nowValue = mockDateService.nowValue.advanced(by: 1)
                    continuation.resume(returning: $0)
                },
                state: VersionSevenUUIDGenerator.State(randomNumberGenerator: mockRandomNumberGenerator)
            )

            // For this test we don't care about the results, just that the system slept to wait
            // for the next timestamp value.
            _ = generator.new()

            // We trigger the first one with the max values, then we expect this second call to trigger the sleep.
            _ = generator.new()
        }

        #expect(sleepLength == argument.expectedSleepMicroseconds)
    }
}
