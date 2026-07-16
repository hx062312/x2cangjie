// Package: jansi
package jansi

// Imports Begin
import jansi.compat.*
import std.fs.*
import std.process.Process
import std.regex.Regex
// Imports End

public open class MingwSupport {
    // Fields Begin
    var sttyCommand: String = throw Exception('TODO')
    var ttyCommand: String = throw Exception('TODO')
    var columnsPatterns: Regex = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public open func getConsoleName(stdout: Bool): String {
        throw Exception('TODO')
    }

    public open func getTerminalWidth(name: String): Int32 {
        throw Exception('TODO')
    }

    private static func waitAndCapture(p: Process): String {
        throw Exception('TODO')
    }

    private func getRedirect(fd: FileDescriptor): JavaLangProcessBuilderRedirect {
        throw Exception('TODO')
    }

    // Methods End
}

