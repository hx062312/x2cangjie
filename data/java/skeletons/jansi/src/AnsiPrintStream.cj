// Package: jansi
package jansi

// Imports Begin
// Imports End

class AnsiPrintStream <: PrintStream {
    // Fields Begin
    // Fields End

    // Methods Begin
    protected func getOut(): Any {
        throw Exception('TODO')
    }

    public func getType(): Any {
        throw Exception('TODO')
    }

    public func getColors(): Any {
        throw Exception('TODO')
    }

    public func getMode(): Any {
        throw Exception('TODO')
    }

    public func setMode(ansiMode: Any): Unit {
        throw Exception('TODO')
    }

    public func isResetAtUninstall(): Bool {
        throw Exception('TODO')
    }

    public func setResetAtUninstall(resetAtClose: Bool): Unit {
        throw Exception('TODO')
    }

    public func getTerminalWidth(): Int64 {
        throw Exception('TODO')
    }

    public func install(): Unit {
        throw Exception('TODO')
    }

    public func uninstall(): Unit {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

