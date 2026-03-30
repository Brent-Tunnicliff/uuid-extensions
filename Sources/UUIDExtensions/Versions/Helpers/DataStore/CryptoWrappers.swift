// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public import Crypto
public import Foundation

// MARK: - Crypto Wrappers

// Since Crypto is a seperate package, lets wrap it for public types
// so consumers don't have to add it to their dependancies too.
// Most of the documentation I just copied from the source.

// MARK: SymmetricKey

/// A symmetric cryptographic key.
public struct SymmetricKey {
    /// The number of bits in the key.
    public var bitCount: Int {
        wrapped.bitCount
    }

    let wrapped: Crypto.SymmetricKey

    /// Generates a new random key of the given size.
    ///
    /// - Parameter size: The size of the key to generate. You can use one of the standard
    /// sizes, like ``SymmetricKeySize/bits256``, or you can create a key of
    /// custom length by initializing a ``SymmetricKeySize`` instance with a
    /// non-standard value.
    public init(size: SymmetricKeySize) {
        self.wrapped = Crypto.SymmetricKey(size: size.wrapped)
    }

    /// Creates a key from the given data.
    ///
    /// - Parameter data: The contiguous bytes from which to create the key.
    public init<D>(data: D) where D: ContiguousBytes {
        self.wrapped = Crypto.SymmetricKey(data: data)
    }

    /// Wraps the swift-crypto SymmetricKey object.
    ///
    /// If not using that dependancy, then use another initialiser to create the key instead.
    public init(wrapping wrapped: Crypto.SymmetricKey) {
        self.wrapped = wrapped
    }
}

extension SymmetricKey: ContiguousBytes {
    /// Calls the given closure with the contents of underlying storage.
    ///
    /// - note: Calling `withUnsafeBytes` multiple times does not guarantee that
    ///         the same buffer pointer will be passed in every time.
    /// - warning: The buffer argument to the body should not be stored or used
    ///            outside of the lifetime of the call to the closure.
    public func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        try wrapped.withUnsafeBytes(body)
    }
}

extension SymmetricKey: Hashable {
    /// Hashes the essential components of this value by feeding them into the given hasher.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrapped.bitCount)
        hasher.combine(wrapped.withUnsafeBytes { Data($0) })
    }
}

extension SymmetricKey: Sendable {}

// MARK: SymmetricKeySize

/// The sizes that a symmetric cryptographic key can take.
public struct SymmetricKeySize {
    /// The number of bits in the key.
    public var bitCount: Int {
        wrapped.bitCount
    }

    let wrapped: Crypto.SymmetricKeySize

    /// A size of 128 bits.
    public static let bits128 = SymmetricKeySize(wrapped: .bits128)

    /// A size of 192 bits.
    public static let bits192 = SymmetricKeySize(wrapped: .bits192)

    /// A size of 256 bits.
    public static let bits256 = SymmetricKeySize(wrapped: .bits256)

    /// Creates a new key size of the given length.
    ///
    /// In most cases, you can use one of the standard key sizes, like bits256.
    /// If instead you need a key with a non-standard size, use the
    /// ``init(bitCount:)`` initializer to create a custom key size.
    ///
    /// - Parameter bitCount: The number of bits in the key size.
    public init(bitCount: Int) {
        self.wrapped = Crypto.SymmetricKeySize(bitCount: bitCount)
    }

    private init(wrapped: Crypto.SymmetricKeySize) {
        self.wrapped = wrapped
    }
}

extension SymmetricKeySize: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    public static func == (lhs: SymmetricKeySize, rhs: SymmetricKeySize) -> Bool {
        lhs.wrapped.bitCount == rhs.wrapped.bitCount
    }
}

extension SymmetricKeySize: Sendable {}
