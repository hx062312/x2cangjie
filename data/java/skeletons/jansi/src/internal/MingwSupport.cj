// Package: jansi.internal
package jansi.internal

// Imports Begin
// Imports End

class MingwSupport {
    // Fields Begin
    let sttyCommand: String = throw Exception('TODO')
    let ttyCommand: String = throw Exception('TODO')
    let columnsPatterns: Regex = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public func getConsoleName(stdout: Bool): String {
        throw Exception('TODO')
    }

    public func getTerminalWidth(name: String): Int64 {
        throw Exception('TODO')
    }

    private static func waitAndCapture(p: Any): String {
        throw Exception('TODO')
    }

    private func getRedirect(fd: Any): Any {
        throw Exception('TODO')
    }

    // Methods End
}

