// Package: jansi
package jansi

// Imports Begin
import charset4cj.*
import std.collection.ArrayList
import std.io.OutputStream
// Imports End

public open class AnsiOutputStream {
    // Fields Begin
    static let RESET_CODE: Array<Int8> = throw Exception('TODO')
    static let LOOKING_FOR_FIRST_ESC_CHAR: Int32 = throw Exception('TODO')
    static let LOOKING_FOR_SECOND_ESC_CHAR: Int32 = throw Exception('TODO')
    static let LOOKING_FOR_NEXT_ARG: Int32 = throw Exception('TODO')
    static let LOOKING_FOR_STR_ARG_END: Int32 = throw Exception('TODO')
    static let LOOKING_FOR_INT_ARG_END: Int32 = throw Exception('TODO')
    static let LOOKING_FOR_OSC_COMMAND: Int32 = throw Exception('TODO')
    static let LOOKING_FOR_OSC_COMMAND_END: Int32 = throw Exception('TODO')
    static let LOOKING_FOR_OSC_PARAM: Int32 = throw Exception('TODO')
    static let LOOKING_FOR_ST: Int32 = throw Exception('TODO')
    static let LOOKING_FOR_CHARSET: Int32 = throw Exception('TODO')
    static let FIRST_ESC_CHAR: Int32 = throw Exception('TODO')
    static let SECOND_ESC_CHAR: Int32 = throw Exception('TODO')
    static let SECOND_OSC_CHAR: Int32 = throw Exception('TODO')
    static let BEL: Int32 = throw Exception('TODO')
    static let SECOND_ST_CHAR: Int32 = throw Exception('TODO')
    static let SECOND_CHARSET0_CHAR: Int32 = throw Exception('TODO')
    static let SECOND_CHARSET1_CHAR: Int32 = throw Exception('TODO')
    var ap: AnsiProcessor = throw Exception('TODO')
    static let MAX_ESCAPE_SEQUENCE_LENGTH: Int32 = throw Exception('TODO')
    var buffer: Array<Int8> = throw Exception('TODO')
    var pos: Int32 = throw Exception('TODO')
    var startOfValue: Int32 = throw Exception('TODO')
    var options: ArrayList<Any> = throw Exception('TODO')
    var state: Int32 = throw Exception('TODO')
    var cs: Charset = throw Exception('TODO')
    var width: AnsiOutputStream_WidthSupplier = throw Exception('TODO')
    var processor: AnsiProcessor = throw Exception('TODO')
    var type__: AnsiType = throw Exception('TODO')
    var colors: AnsiColors = throw Exception('TODO')
    var installer: AnsiOutputStream_IoRunnable = throw Exception('TODO')
    var uninstaller: AnsiOutputStream_IoRunnable = throw Exception('TODO')
    var mode: AnsiMode = throw Exception('TODO')
    var resetAtUninstall: Bool = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(os: OutputStream, width: AnsiOutputStream_WidthSupplier, mode: AnsiMode, processor: AnsiProcessor, type__: AnsiType, colors: AnsiColors, cs: Charset, installer: AnsiOutputStream_IoRunnable, uninstaller: AnsiOutputStream_IoRunnable, resetAtUninstall: Bool) {
        throw Exception('TODO')
    }

    public open func getTerminalWidth(): Int32 {
        throw Exception('TODO')
    }

    public open func getType(): AnsiType {
        throw Exception('TODO')
    }

    public open func getColors(): AnsiColors {
        throw Exception('TODO')
    }

    public open func getMode(): AnsiMode {
        throw Exception('TODO')
    }

    public open func setMode(mode: AnsiMode): Unit {
        throw Exception('TODO')
    }

    public open func isResetAtUninstall(): Bool {
        throw Exception('TODO')
    }

    public open func setResetAtUninstall(resetAtUninstall: Bool): Unit {
        throw Exception('TODO')
    }

    public open func write(data: Int32): Unit {
        throw Exception('TODO')
    }

    private func processCharsetSelect(): Unit {
        throw Exception('TODO')
    }

    private func processOperatingSystemCommand(): Unit {
        throw Exception('TODO')
    }

    private func processEscapeCommand(data: Int32): Unit {
        throw Exception('TODO')
    }

    private func reset(skipBuffer: Bool): Unit {
        throw Exception('TODO')
    }

    public open func install(): Unit {
        throw Exception('TODO')
    }

    public open func uninstall(): Unit {
        throw Exception('TODO')
    }

    public open func close(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

public interface AnsiOutputStream_IoRunnable {
    // Methods Begin
    func run(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

public interface AnsiOutputStream_WidthSupplier {
    // Methods Begin
    func getTerminalWidth(): Int32 {
        throw Exception('TODO')
    }

    // Methods End
}

public open class AnsiOutputStream_ZeroWidthSupplier <: AnsiOutputStream_WidthSupplier {
    // Fields Begin
    // Fields End

    // Methods Begin
    public open func getTerminalWidth(): Int32 {
        throw Exception('TODO')
    }

    // Methods End
}

