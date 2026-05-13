// Package: jansi
package jansi

// Imports Begin
import std.regex.Regex
// Imports End

public open class MingwSupport {
    // Fields Begin
    let sttyCommand: String = throw Exception('TODO')
    let ttyCommand: String = throw Exception('TODO')
    let columnsPatterns: Regex = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public open func getConsoleName(stdout: Bool): String {
        throw Exception('TODO')
    }

    public open func getTerminalWidth(name: String): Int64 {
        throw Exception('TODO')
    }

    private static func waitAndCapture(p: Process): String {
        throw Exception('TODO')
    }

    private func getRedirect(fd: Any): Any {
        throw Exception('TODO')
    }

    // Methods End
}

