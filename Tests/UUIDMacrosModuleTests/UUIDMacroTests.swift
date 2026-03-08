import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing
import UUIDMacrosModule

@Suite
struct UUIDMacroTests {
    let testMacros = ["uuid": MacroSpec(type: UUIDMacro.self)]

    #if canImport(FoundationEssentials)
        private let foundation = "FoundationEssentials"
    #else
        private let foundation = "Foundation"
    #endif

    enum ValidArgument: CaseIterable {
        case empty
        case v1
        case v2
        case v3
        case v4
        case v5
        case v6
        case v7
        case v8

        var value: String {
            switch self {
            case .empty: "00000000-0000-0000-0000-000000000000"
            case .v1: "d0547a36-1acc-11f1-8de9-0242ac120002"
            case .v2: "000003e8-1acd-21f1-9300-325096b39f47"
            case .v3: "5520a6c7-6f8e-39b8-bff3-6e0244111601"
            case .v4: "95034084-7faa-4311-88dc-3cbc8052b359"
            case .v5: "a52a8b4b-2abb-59c5-9e91-20b64921ef7f"
            case .v6: "1f11acd5-ef37-6f30-aaf3-2d422ecf5bf8"
            case .v7: "019cccab-2120-7205-921b-2284bb4240fe"
            case .v8: "5b487836-5e81-8d4b-9997-019cccaf24af"
            }
        }
    }

    @Test(arguments: ValidArgument.allCases)
    func valid(_ argument: ValidArgument) {
        let uuid = argument.value
        let input = "#uuid(\"\(uuid)\")"
        let expectedResult = "\(foundation).UUID(uuidString: \"\(uuid)\")!"

        assertMacroExpansion(
            input,
            expandedSource: expectedResult,
            macroSpecs: testMacros,
            failureHandler: record(failure:)
        )
    }

    enum InvalidArgument: CaseIterable {
        case emptyString
        case missingDigit
        case nonUUIDString
        case validUUIDWithWhiteSpaceLeading
        case validUUIDWithWhiteSpaceInMiddle
        case validUUIDWithWhiteSpaceTrailing

        var value: String {
            switch self {
            case .emptyString: ""
            case .missingDigit: "d0547a36-1acc-11f1-8de9-0242ac12000"
            case .nonUUIDString: "hello there :)"
            case .validUUIDWithWhiteSpaceLeading: " 5b487836-5e81-8d4b-9997-019cccaf24af"
            case .validUUIDWithWhiteSpaceInMiddle: "5b487836-5e81-8d4b-9997-019cccaf24af "
            case .validUUIDWithWhiteSpaceTrailing: "5b487836-5e81-8d4b- 9997-019cccaf24af"
            }
        }
    }

    @Test(arguments: InvalidArgument.allCases)
    func invalid(_ argument: InvalidArgument) {
        let value = argument.value
        let input = "#uuid(\"\(value)\")"
        let expectedResult = input

        assertMacroExpansion(
            input,
            expandedSource: expectedResult,
            diagnostics: [
                DiagnosticSpec(
                    message: "'\(value)' is not a valid UUID",
                    line: 1,
                    column: 1
                )
            ],
            macroSpecs: testMacros,
            failureHandler: record(failure:)
        )
    }

    private func record(failure: TestFailureSpec) {
        Issue.record(
            Comment(rawValue: failure.message),
            sourceLocation: SourceLocation(
                fileID: failure.location.fileID,
                filePath: failure.location.filePath,
                line: failure.location.line,
                column: failure.location.column
            )
        )
    }
}
