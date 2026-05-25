// Package: jansi
package jansi

// Imports Begin
import std.collection.ArrayList
import std.core.*
import std.io.OutputStream
// Imports End

public open class AnsiOutputStream {
    // Fields Begin
    static let RESET_CODE: Array<Byte> = throw Exception('TODO')  // Already translated, compilation failed
    static let LOOKING_FOR_FIRST_ESC_CHAR: Int64 = 0
    static let LOOKING_FOR_SECOND_ESC_CHAR: Int64 = 1
    static let LOOKING_FOR_NEXT_ARG: Int64 = 2
    static let LOOKING_FOR_STR_ARG_END: Int64 = 3
    static let LOOKING_FOR_INT_ARG_END: Int64 = 4
    static let LOOKING_FOR_OSC_COMMAND: Int64 = 5
    static let LOOKING_FOR_OSC_COMMAND_END: Int64 = 6
    static let LOOKING_FOR_OSC_PARAM: Int64 = 7
    static let LOOKING_FOR_ST: Int64 = 8
    static let LOOKING_FOR_CHARSET: Int64 = 9
    static let FIRST_ESC_CHAR: Int64 = 27
    static let SECOND_ESC_CHAR: Int64 = 0x5B  // Already translated, compilation failed
    static let SECOND_OSC_CHAR: Int64 = 0x5D
    static let BEL: Int64 = 7
    static let SECOND_ST_CHAR: Int64 = 0x5C  // Already translated, compilation failed
    static let SECOND_CHARSET0_CHAR: Int64 = 40
    static let SECOND_CHARSET1_CHAR: Int64 = 41
    var ap: AnsiProcessor = throw Exception('TODO')
    static let MAX_ESCAPE_SEQUENCE_LENGTH: Int64 = 100
    let buffer: Array<Byte> = throw Exception('TODO')  // Already translated, compilation failed
    var pos: Int64 = 0
    var startOfValue: Int64 = 0
    let options: ArrayList<Object> = ArrayList<Object>()
    var state: Int64 = LOOKING_FOR_FIRST_ESC_CHAR
    let cs: Any = throw Exception('TODO')  // Already translated, compilation failed
    let width: AnsiOutputStream_WidthSupplier = throw Exception('TODO')  // Already translated, compilation failed
    let processor: AnsiProcessor = throw Exception("TODO")  // Already translated, compilation failed
    let type__: AnsiType = throw Exception('TODO')
    let colors: AnsiColors = throw Exception('TODO')
    let installer: AnsiOutputStream_IoRunnable = throw Exception('TODO')
    let uninstaller: AnsiOutputStream_IoRunnable = throw Exception('TODO')
    var mode: AnsiMode = throw Exception('TODO')
    var resetAtUninstall: Bool = false
    // Fields End

    // Methods Begin
    public init(os: OutputStream, width: AnsiOutputStream_WidthSupplier, mode: AnsiMode, processor: AnsiProcessor, type__: AnsiType, colors: AnsiColors, cs: Any, installer: AnsiOutputStream_IoRunnable, uninstaller: AnsiOutputStream_IoRunnable, resetAtUninstall: Bool) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getTerminalWidth(): Int64 {
                return width.getTerminalWidth()
    }

    public open func getType(): AnsiType {
                return type__
    }

    public open func getColors(): AnsiColors {
                return this.colors
    }

    public open func getMode(): AnsiMode {
                return mode
    }

    public open func setMode(mode: AnsiMode): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func isResetAtUninstall(): Bool {
                return this.resetAtUninstall
    }

    public open func setResetAtUninstall(resetAtUninstall: Bool): Unit {
                this.resetAtUninstall = resetAtUninstall
    }

    public open func write(data: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func processCharsetSelect(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func processOperatingSystemCommand(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func processEscapeCommand(data: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func reset(skipBuffer: Bool): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func install(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func uninstall(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
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
                throw Exception("TODO")
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

