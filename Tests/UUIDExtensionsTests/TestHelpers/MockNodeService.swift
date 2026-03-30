// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
@testable import UUIDExtensions

final class MockNodeService: NodeService, @unchecked Sendable {
    private let lock = NSLock()

    private var _node: Node
    var node: Node {
        get { lock.withLock { _node } }
        set { lock.withLock { _node = newValue } }
    }

    init() {
        // Example node from [Appendix A. Test Vectors](https://www.rfc-editor.org/rfc/rfc9562#name-test-vectors).
        self._node = (0x9F, 0x6B, 0xDE, 0xCE, 0xD8, 0x46)
    }
}
