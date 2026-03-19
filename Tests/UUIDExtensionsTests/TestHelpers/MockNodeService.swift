// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

@testable import UUIDExtensions

struct MockNodeService: NodeService {
    // Example node from [Appendix A. Test Vectors](https://www.rfc-editor.org/rfc/rfc9562#name-test-vectors).
    let node: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) = (0x9F, 0x6B, 0xDE, 0xCE, 0xD8, 0x46)
}
