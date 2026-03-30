// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import PackageDescription

// MARK: - Package

let package = Package(
    name: "uuid-extensions",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "UUIDExtensions",
            targets: ["UUIDExtensions"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", .upToNextMajor(from: "4.2.0")),
        .package(url: "https://github.com/Brent-Tunnicliff/swift-format-plugin", .upToNextMajor(from: "2.0.0")),
    ],
    targets: [
        .target(
            name: "UUIDExtensions",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto"),
            ]
        ),
        .testTarget(
            name: "UUIDExtensionsTests",
            dependencies: [
                "UUIDExtensions",
                .product(name: "Crypto", package: "swift-crypto"),
            ]
        )
    ]
)

// MARK: - Common target settings

// Sets values that are common for every target.
// Plugins cannot contain plugins or swift settings.
for target in package.targets where target.type != .plugin {
    // MARK: Plugins

    let commonPlugins: [PackageDescription.Target.PluginUsage] = [
        .plugin(name: "LintBuildPlugin", package: "swift-format-plugin")
    ]

    target.plugins = (target.plugins ?? []) + commonPlugins

    // MARK: Swift compliler settings

    let commonSwiftSettings: [PackageDescription.SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + commonSwiftSettings
}
