// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

// MARK: - V7Configuration

/// Configuration for the generating of UUID v7.
///
/// Documented in <https://www.rfc-editor.org/rfc/rfc9562#section-6.2>.
public struct V7Configuration {
    let counter: Counter?
    let increasedClockPrecision: Bool

    init(
        counter: Counter? = nil,
        increasedClockPrecision: Bool = false
    ) {
        self.counter = counter
        self.increasedClockPrecision = increasedClockPrecision
    }
}

extension V7Configuration {
    /// Default configuration without any optional additions.
    public static let `default` = V7Configuration()

    /// UUID will generate with an increased clock precision.
    ///
    /// Increased clock precision means using fractions of a millisecond in place of the random bits immediately following the timestamp.
    ///
    /// Based on method 3 of <https://www.rfc-editor.org/rfc/rfc9562#section-6.2>.
    public static let withIncreasedClockPrecision = V7Configuration(increasedClockPrecision: true)

    /// UUID will generate with an increased clock precision and a monotonic random counter.
    ///
    /// Increased clock precision means using fractions of a millisecond in place of the random bits immediately following the timestamp.
    ///
    /// Monotonic Random Counter makes sure that the random values are an increment of any previous generated with the same timestamp.
    ///
    /// Based on methods 2 and 3 of <https://www.rfc-editor.org/rfc/rfc9562#section-6.2>.
    public static let withIncreasedClockPrecisionAndMonotonicRandomCounter = V7Configuration(
        counter: .monotonicRandom,
        increasedClockPrecision: true
    )

    /// UUID will generate with an increased clock precision and a fixed length counter.
    ///
    /// Increased clock precision means using fractions of a millisecond in place of the random bits immediately following the timestamp.
    ///
    /// Fixed length Counter will use a random value for generating UUID, but if the time stamp is the same as previous it will instead increment the same counter value.
    ///
    /// Based on methods 1 and 3 of <https://www.rfc-editor.org/rfc/rfc9562#section-6.2>.
    public static let withIncreasedClockPrecisionAndFixedLengthCounter = V7Configuration(
        counter: .fixedLength,
        increasedClockPrecision: true
    )

    /// UUID will generate with a monotonic random counter.
    ///
    /// Monotonic Random Counter makes sure that the random values are an increment of any previous generated with the same timestamp.
    ///
    /// Based on method 2 of <https://www.rfc-editor.org/rfc/rfc9562#section-6.2>.
    public static let withMonotonicRandomCounter = V7Configuration(counter: .monotonicRandom)

    /// UUID will generate with a fixed length counter.
    ///
    /// Fixed length Counter will use a random value for generating UUID, but if the time stamp is the same as previous it will instead increment the same counter value.
    ///
    /// Based on method 1 of <https://www.rfc-editor.org/rfc/rfc9562#section-6.2>.
    public static let withFixedLengthCounter = V7Configuration(counter: .fixedLength)
}

// MARK: Hashable

extension V7Configuration: Hashable {}

// MARK: Sendable

extension V7Configuration: Sendable {}

// MARK: - UUIDV7Option.Counter

extension V7Configuration {
    enum Counter {
        case fixedLength
        case monotonicRandom
    }
}

// MARK: Hashable

extension V7Configuration.Counter: Hashable {}

// MARK: Sendable

extension V7Configuration.Counter: Sendable {}
