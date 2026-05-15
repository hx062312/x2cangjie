// Package: jansi
package jansi

// Imports Begin
import std.collection.ArrayList
import std.io.OutputStream
// Imports End

public open class AnsiOutputStream {
    // Fields Begin
    static let RESET_CODE: Array<Byte> = throw Exception('TODO')
    static let LOOKING_FOR_FIRST_ESC_CHAR: Int64 = throw Exception('TODO')
    static let LOOKING_FOR_SECOND_ESC_CHAR: Int64 = throw Exception('TODO')
    static let LOOKING_FOR_NEXT_ARG: Int64 = throw Exception('TODO')
    static let LOOKING_FOR_STR_ARG_END: Int64 = throw Exception('TODO')
    static let LOOKING_FOR_INT_ARG_END: Int64 = throw Exception('TODO')
    static let LOOKING_FOR_OSC_COMMAND: Int64 = throw Exception('TODO')
    static let LOOKING_FOR_OSC_COMMAND_END: Int64 = throw Exception('TODO')
    static let LOOKING_FOR_OSC_PARAM: Int64 = throw Exception('TODO')
    static let LOOKING_FOR_ST: Int64 = throw Exception('TODO')
    static let LOOKING_FOR_CHARSET: Int64 = throw Exception('TODO')
    static let FIRST_ESC_CHAR: Int64 = throw Exception('TODO')
    static let SECOND_ESC_CHAR: Int64 = throw Exception('TODO')
    static let SECOND_OSC_CHAR: Int64 = throw Exception('TODO')
    static let BEL: Int64 = throw Exception('TODO')
    static let SECOND_ST_CHAR: Int64 = throw Exception('TODO')
    static let SECOND_CHARSET0_CHAR: Int64 = throw Exception('TODO')
    static let SECOND_CHARSET1_CHAR: Int64 = throw Exception('TODO')
    var ap: AnsiProcessor = throw Exception('TODO')
    static let MAX_ESCAPE_SEQUENCE_LENGTH: Int64 = throw Exception('TODO')
    let buffer: Array<Byte> = throw Exception('TODO')
    var pos: Int64 = throw Exception('TODO')
    var startOfValue: Int64 = throw Exception('TODO')
    let options: ArrayList<Object> = throw Exception('TODO')
    var state: Int64 = throw Exception('TODO')
    let cs: Any = throw Exception('TODO')
    let width: AnsiOutputStream_WidthSupplier = throw Exception('TODO')
    let processor: AnsiProcessor = throw Exception('TODO')
    let type__: AnsiType = throw Exception('TODO')
    let colors: AnsiColors = throw Exception('TODO')
    let installer: AnsiOutputStream_IoRunnable = throw Exception('TODO')
    let uninstaller: AnsiOutputStream_IoRunnable = throw Exception('TODO')
    var mode: AnsiMode = throw Exception('TODO')
    var resetAtUninstall: Bool = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(os: OutputStream, width: AnsiOutputStream_WidthSupplier, mode: AnsiMode, processor: AnsiProcessor, type__: AnsiType, colors: AnsiColors, cs: Any, installer: AnsiOutputStream_IoRunnable, uninstaller: AnsiOutputStream_IoRunnable, resetAtUninstall: Bool) {
        throw Exception('TODO')
    }

    public open func getTerminalWidth(): Int64 {
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

    public open func write(data: Int64): Unit {
        throw Exception('TODO')
    }

    private func processCharsetSelect(): Unit {
        throw Exception('TODO')
    }

    private func processOperatingSystemCommand(): Unit {
        throw Exception('TODO')
    }

    private func processEscapeCommand(data: Int64): Unit {
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
        throw Exception('TODO')
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
    func getTerminalWidth(): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

public open class AnsiOutputStream_ZeroWidthSupplier <: AnsiOutputStream_WidthSupplier {
    // Fields Begin
    // Fields End

    // Methods Begin
    public open func getTerminalWidth(): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

