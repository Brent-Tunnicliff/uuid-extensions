// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(SwiftSyntax)

    public import SwiftSyntax
    import SwiftSyntaxBuilder
    public import SwiftSyntaxMacros

    #if canImport(FoundationEssentials)
        import FoundationEssentials
    #else
        import Foundation
    #endif

    /// Macro for checking if uuid is valid at compile time and removing the usual optional.
    public struct UUIDMacro: ExpressionMacro {
        /// Expand a macro described by the given freestanding macro expansion
        /// within the given context to produce a replacement expression.
        public static func expansion(
            of node: some FreestandingMacroExpansionSyntax,
            in context: some MacroExpansionContext
        ) throws -> ExprSyntax {
            guard
                let argument = node.arguments.first?.expression,
                let literal = argument.as(StringLiteralExprSyntax.self),
                case .stringSegment(let segment) = literal.segments.first
            else {
                throw Error.notStringLiteral
            }

            let text = segment.content.text
            guard UUID(uuidString: text) != nil else {
                throw Error.invalidUUID(text)
            }

            // Force unwrapping should be safe because the build would have failed if this returned nil.
            return "Foundation.UUID(uuidString: \(argument))!"
        }
    }

    extension UUIDMacro {
        enum Error {
            case notStringLiteral
            case invalidUUID(String)
        }
    }

    extension UUIDMacro.Error: CustomStringConvertible {
        var description: String {
            switch self {
            case .notStringLiteral: "Argument is not a string literal"
            case let .invalidUUID(value): "'\(value)' is not a valid UUID"
            }
        }
    }

    extension UUIDMacro.Error: Swift.Error {}

#endif
