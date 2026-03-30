// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(SwiftSyntax)

    import SwiftCompilerPlugin
    import SwiftSyntaxMacros

    @main
    struct UUIDMacrosModulePlugin: CompilerPlugin {
        let providingMacros: [any Macro.Type] = [UUIDMacro.self]
    }

#endif
