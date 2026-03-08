// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct UUIDMacrosModulePlugin: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [UUIDMacro.self]
}
