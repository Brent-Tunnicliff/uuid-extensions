# uuid-extensions

The purpose of this project is:

1. Expand Foundation UUID creation to support various versions as per [RFC 9562](https://www.rfc-editor.org/rfc/rfc9562) as creating a new Foundation.UUID object uses v4.
2. Provide a macro for creating UUID's with StaticString that fails the build instead of returning optional if the input is invalid.
3. Provide constants for `nil` and `max` UUIDs. 
4. Support all swift platforms that can import Foundation. 

## Installation

Import via SPM:

```swift
let package = Package(
    // ...
    dependencies: [
        .package(url: "https://github.com/Brent-Tunnicliff/uuid-extensions.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            // ...
            dependencies: [
                .product(name: "UUIDExtensions", package: "uuid-extensions"),
            ]
```

## How to use

### Versions

TODO: fill out.

### Macro

This freestanding macro can be used directly wherever the UUID needs to be created with:

```swift
import UUIDExtensions

let id: UUID = #uuid("95034084-7faa-4311-88dc-3cbc8052b359")
```

The input is type "StaticString", so the value must be known at compile time.

If the input does not have a valid UUID format, then you will get a compile error that it isn't a valid UUID.

```swift
// Compile error: 'hello :)' is not a valid UUID
let id: UUID = #uuid("hello :)")
```

### Constants

The project has a small number of constants defined in [RFC 9562](https://www.rfc-editor.org/rfc/rfc9562).
They are added as static extension to the Foundation.UUID type.

#### nil

Nil UUID has all 128 bits set to 0.

```swift
// 00000000-0000-0000-0000-000000000000
let id: UUID = .nil
```

<https://www.rfc-editor.org/rfc/rfc9562#section-5.9>

#### max

Max UUID has all 128 bits set to 1.

```swift
// FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF
let id: UUID = .max
```

<https://www.rfc-editor.org/rfc/rfc9562#section-5.10>.

#### dns

DNS namespace ID for v3 and v5 UUID's.

```swift
// 6BA7B810-9DAD-11D1-80B4-00C04FD430C8
let id: UUID = .dns
```

<https://www.rfc-editor.org/rfc/rfc9562#section-6.6>

#### url

URL namespace ID for v3 and v5 UUID's.

```swift
// 6BA7B811-9DAD-11D1-80B4-00C04FD430C8
let id: UUID = .url
```

<https://www.rfc-editor.org/rfc/rfc9562#section-6.6>

#### oid

OID namespace ID for v3 and v5 UUID's.

```swift
// 6BA7B812-9DAD-11D1-80B4-00C04FD430C8
let id: UUID = .oid
```

<https://www.rfc-editor.org/rfc/rfc9562#section-6.6>

#### x500

X500 namespace ID for v3 and v5 UUID's.

```swift
// 6BA7B814-9DAD-11D1-80B4-00C04FD430C8
let id: UUID = .x500
```

<https://www.rfc-editor.org/rfc/rfc9562#section-6.6>

## Source Stability

The versioning of this package follows [Semantic Versioning](https://semver.org/). Source breaking changes to public API require a new major version.

We'd like this package to quickly embrace Swift language and toolchain improvements, and expect the latest Swift toolchains to be used (i.e. latest public Xcode version). So we will include updating the Swift version of the package as a new minor version bump.

## Disclaimer

I only pretend to know what I am doing. If you find something wrong please raise an issue to let me know.
