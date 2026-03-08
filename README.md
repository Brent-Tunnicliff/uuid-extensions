# swift-uuid

The purpose of this project is:

1. Expand Foundation UUID creation to support various versions as per [RFC 9562](https://www.rfc-editor.org/rfc/rfc9562) as creating a new Foundation.UUID object uses v4.
2. Provide a macro for creating UUID's with StaticString that fails the build instead of returning optional if the input is invalid.
3. Support all swift platforms that can import Foundation or FoundationEssentials.

## Installation

TODO

## How to use

TODO

## Source Stability

The versioning of this package follows [Semantic Versioning](https://semver.org/). Source breaking changes to public API require a new major version.

We'd like this package to quickly embrace Swift language and toolchain improvements, and expect the latest Swift toolchains to be used (i.e. latest public Xcode version). So we will include updating the Swift version of the package as a new minor version bump.
