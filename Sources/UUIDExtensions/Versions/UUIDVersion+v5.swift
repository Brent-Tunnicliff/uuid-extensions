// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Crypto

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#else
    public import Foundation
#endif

// MARK: - UUIDVersion

extension UUIDVersion {
    /// [UUID version 5](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-5).
    ///
    /// The value is generated based on the namespace and name inputs.
    /// If you input the same values later you get the same UUID.
    /// Same structure as ``v3(namespace:name:)``, but uses SHA-1 to hash the inputs.
    ///
    /// - Parameters:
    ///    - namespace: Namespace to use for generating the UUID.
    ///      Can be a standard one like `dns`, `url`, `oid`, `x500`, or a custom one of your choice.
    ///    - name: The name to use for generating the UUID.
    /// - Returns: ``UUIDVersion`` configured as `v5` based on the inputs.
    public static func v5(
        namespace: UUID,
        name: String
    ) -> UUIDVersion {
        UUIDVersion(
            generator: VersionFiveUUIDGenerator(
                name: name,
                namespace: namespace
            )
        )
    }
}

// MARK: - VersionFiveUUIDGenerator

struct VersionFiveUUIDGenerator {
    let id = 5
    private let name: String
    private let namespace: UUID
    private let randomNumberGenerator: any RandomNumberGenerator

    fileprivate init(
        name: String,
        namespace: UUID
    ) {
        self.init(
            name: name,
            namespace: namespace,
            randomNumberGenerator: .default
        )
    }

    init(
        name: String,
        namespace: UUID,
        randomNumberGenerator: any RandomNumberGenerator
    ) {
        self.namespace = namespace
        self.name = name
        self.randomNumberGenerator = randomNumberGenerator
    }
}

// MARK: - Equatable

extension VersionFiveUUIDGenerator: Equatable {
    static func == (lhs: VersionFiveUUIDGenerator, rhs: VersionFiveUUIDGenerator) -> Bool {
        lhs.namespace == rhs.namespace
            && lhs.name == rhs.name
    }
}

// MARK: - Hashable

extension VersionFiveUUIDGenerator: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(namespace)
    }
}

// MARK: UUIDGenerator

extension VersionFiveUUIDGenerator: UUIDGenerator {
    func new() -> UUID {
        // Combine namespace and name into the same data object
        var namespaceID = namespace.uuid
        var data = withUnsafeBytes(of: &namespaceID) { Data($0) }
        data.append(contentsOf: name.utf8)

        // Hash with SHA-1
        let digest = Insecure.SHA1.hash(data: data)
        var bytes = Array(digest.prefix(16))

        // Version 5
        bytes[6] = (bytes[6] & 0x0F) | 0x50

        // Variant
        bytes[8] = (bytes[8] & 0x3F) | 0x80

        return UUID(
            uuid: (
                bytes[0],
                bytes[1],
                bytes[2],
                bytes[3],
                bytes[4],
                bytes[5],
                bytes[6],
                bytes[7],
                bytes[8],
                bytes[9],
                bytes[10],
                bytes[11],
                bytes[12],
                bytes[13],
                bytes[14],
                bytes[15],
            )
        )
    }
}
