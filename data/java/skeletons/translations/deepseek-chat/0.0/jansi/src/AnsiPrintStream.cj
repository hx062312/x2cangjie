// Package: jansi
package jansi

// Imports Begin
import std.core.*
// Imports End

public open class AnsiPrintStream {
    // Fields Begin
    // Fields End

    // Methods Begin
    public init(out: AnsiOutputStream, autoFlush: Bool, args: Any) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private static func determineEncoding(args: Any): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected open func getOut(): AnsiOutputStream {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getType(): AnsiType {
                return getOut().getType()
    }

    public open func getColors(): AnsiColors {
                return getOut().getColors()
    }

    public open func getMode(): AnsiMode {
                return getOut().getMode()
    }

    public open func setMode(ansiMode: AnsiMode): Unit {
                getOut().setMode(ansiMode)
    }

    public open func isResetAtUninstall(): Bool {
                return getOut().isResetAtUninstall()
    }

    public open func setResetAtUninstall(resetAtClose: Bool): Unit {
                getOut().setResetAtUninstall(resetAtClose)
    }

    public open func getTerminalWidth(): Int64 {
                return getOut().getTerminalWidth()
    }

    public open func install(): Unit {
                getOut().install()
    }

    public open func uninstall(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func toString(): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

