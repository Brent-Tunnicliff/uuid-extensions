// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import CompilerPluginSupport
import PackageDescription

// MARK: - Package

// The macro targets can only build on the actual machine you develop with which should be macOS, linux or Windows.
let macroDependencyCondition = TargetDependencyCondition.when(
    platforms: [
        .macOS,
        .linux,
        .windows,
    ]
)

let package = Package(
    name: "uuid-extensions",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13),
        .macOS(.v12),
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
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0"),
    ],
    targets: [
        .target(
            name: "UUIDExtensions",
            dependencies: [
                "UUIDMacros",
                .product(name: "Crypto", package: "swift-crypto"),
            ]
        ),
        .testTarget(
            name: "UUIDExtensionsTests",
            dependencies: [
                "UUIDExtensions",
                // Only adding UUIDMacros so we can check if it is importable for the macro test.
                .targetItem(name: "UUIDMacros", condition: macroDependencyCondition),
            ]
        ),
        .macro(
            name: "UUIDMacros",
            dependencies: [
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax", condition: macroDependencyCondition),
                .product(name: "SwiftSyntax", package: "swift-syntax", condition: macroDependencyCondition),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax", condition: macroDependencyCondition),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax", condition: macroDependencyCondition),
            ]
        ),
        .testTarget(
            name: "UUIDMacrosTests",
            dependencies: [
                .targetItem(name: "UUIDMacros", condition: macroDependencyCondition),
                .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosGenericTestSupport", package: "swift-syntax"),
            ]
        ),
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
