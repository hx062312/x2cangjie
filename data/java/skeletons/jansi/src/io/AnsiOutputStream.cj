// Package: jansi.io
package jansi.io

// Imports Begin
// Imports End

class AnsiOutputStream <: FilterOutputStream {
    // Fields Begin
    static let RESET_CODE: Array<Int8> = throw Exception('TODO')
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
    var ap: Any = throw Exception('TODO')
    static let MAX_ESCAPE_SEQUENCE_LENGTH: Int64 = throw Exception('TODO')
    let buffer: Array<Int8> = throw Exception('TODO')
    var pos: Int64 = throw Exception('TODO')
    var startOfValue: Int64 = throw Exception('TODO')
    let options: ArrayList<Any> = throw Exception('TODO')
    var state: Int64 = throw Exception('TODO')
    let cs: Charset = throw Exception('TODO')
    let width: Any = throw Exception('TODO')
    let processor: Any = throw Exception('TODO')
    let type: Any = throw Exception('TODO')
    let colors: Any = throw Exception('TODO')
    let installer: Any = throw Exception('TODO')
    let uninstaller: Any = throw Exception('TODO')
    var mode: Any = throw Exception('TODO')
    var resetAtUninstall: Bool = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(os: OutputStream, width: Any, mode: Any, processor: Any, type: Any, colors: Any, cs: Charset, installer: Any, uninstaller: Any, resetAtUninstall: Bool) {
        throw Exception('TODO')
    }

    public func getTerminalWidth(): Int64 {
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

    public func setMode(mode: Any): Unit {
        throw Exception('TODO')
    }

    public func isResetAtUninstall(): Bool {
        throw Exception('TODO')
    }

    public func setResetAtUninstall(resetAtUninstall: Bool): Unit {
        throw Exception('TODO')
    }

    public func write(data: Int64): Unit {
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

    public func install(): Unit {
        throw Exception('TODO')
    }

    public func uninstall(): Unit {
        throw Exception('TODO')
    }

    public func close(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

interface IoRunnable {
    // Fields Begin
    // Fields End

    // Methods Begin
    func run(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

interface WidthSupplier {
    // Fields Begin
    // Fields End

    // Methods Begin
    func getTerminalWidth(): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

class ZeroWidthSupplier <: WidthSupplier {
    // Fields Begin
    // Fields End

    // Methods Begin
    public func getTerminalWidth(): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

