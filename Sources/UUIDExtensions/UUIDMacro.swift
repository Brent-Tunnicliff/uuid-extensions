// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#else
    public import Foundation
#endif

/// Macro for checking if uuid is valid at compile time and removing the usual optional.
///
/// - Parameter value: static string to be used for creating the uuid. If not a valid uuid then a compile error is thrown.
@freestanding(expression)
public macro uuid(_ value: StaticString) -> UUID = #externalMacro(module: "UUIDMacros", type: "UUIDMacro")
