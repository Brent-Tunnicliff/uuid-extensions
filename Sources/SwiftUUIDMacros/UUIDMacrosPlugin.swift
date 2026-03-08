// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct UUIDMacrosPlugin: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [UUIDMacro.self]
}
