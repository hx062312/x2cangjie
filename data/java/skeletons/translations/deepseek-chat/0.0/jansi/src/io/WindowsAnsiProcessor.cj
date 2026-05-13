// Package: jansi.io
package jansi.io

// Imports Begin

// Imports End

class WindowsAnsiProcessor <: AnsiProcessor {
    // Fields Begin
    let console: Int64 = throw Exception("TODO")  // Already translated, compilation failed
    static let FOREGROUND_BLACK: Int16 = 0
    static let FOREGROUND_YELLOW: Int16 = (FOREGROUND_RED | FOREGROUND_GREEN) as Int16
    static let FOREGROUND_MAGENTA: Int16 = (FOREGROUND_BLUE | FOREGROUND_RED) as Int16
    static let FOREGROUND_CYAN: Int16 = (FOREGROUND_BLUE | FOREGROUND_GREEN) as Int16
    static let FOREGROUND_WHITE: Int16 = throw Exception('TODO')  // Already translated, compilation failed
    static let BACKGROUND_BLACK: Int16 = throw Exception('TODO')  // Already translated, compilation failed
    static let BACKGROUND_YELLOW: Int16 = throw Exception('TODO')  // Already translated, compilation failed
    static let BACKGROUND_MAGENTA: Int16 = throw Exception('TODO')  // Already translated, compilation failed
    static let BACKGROUND_CYAN: Int16 = throw Exception('TODO')  // Already translated, compilation failed
    static let BACKGROUND_WHITE: Int16 = throw Exception('TODO')  // Already translated, compilation failed
    static let ANSI_FOREGROUND_COLOR_MAP: Array<Int16> = throw Exception('TODO')  // Already translated, compilation failed
    static let ANSI_BACKGROUND_COLOR_MAP: Array<Int16> = throw Exception('TODO')  // Already translated, compilation failed
    let info: CONSOLE_SCREEN_BUFFER_INFO = throw Exception('TODO')  // Already translated, compilation failed
    let originalColors: Int16 = throw Exception('TODO')  // Already translated, compilation failed
    var negative: Bool = throw Exception('TODO')  // Already translated, compilation failed
    var savedX: Int16 = throw Exception('TODO')  // Already translated, compilation failed
    var savedY: Int16 = throw Exception('TODO')  // Already translated, compilation failed
    // Fields End

    // Methods Begin
    public init(ps: OutputStream, console: Int64) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(ps: OutputStream, stdout: Bool) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(ps: OutputStream) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func getConsoleInfo(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func applyAttribute(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func invertAttributeColors(attributes: Int16): Int16 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func applyCursorPosition(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processEraseScreen(eraseOption: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processEraseLine(eraseOption: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processCursorLeft(count: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processCursorRight(count: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processCursorDown(count: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processCursorUp(count: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processCursorTo(row: Int64, col: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processCursorToColumn(x: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processCursorUpLine(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processCursorDownLine(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processSetForegroundColor(color: Int64, bright: Bool): Unit {
        throw Exception('TODO')
    }

    protected override func processSetForegroundColorExt(paletteIndex: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processSetForegroundColorExt(r: Int64, g: Int64, b: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processSetBackgroundColor(color: Int64, bright: Bool): Unit {
        throw Exception('TODO')
    }

    protected override func processSetBackgroundColorExt(paletteIndex: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processSetBackgroundColorExt(r: Int64, g: Int64, b: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processDefaultTextColor(): Unit {
        throw Exception('TODO')
    }

    protected override func processDefaultBackgroundColor(): Unit {
        throw Exception('TODO')
    }

    protected override func processAttributeReset(): Unit {
        throw Exception('TODO')
    }

    protected override func processSetAttribute(attribute: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processSaveCursorPosition(): Unit {
        throw Exception('TODO')
    }

    protected override func processRestoreCursorPosition(): Unit {
        throw Exception('TODO')
    }

    protected override func processInsertLine(optionInt: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processDeleteLine(optionInt: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processChangeWindowTitle(label: String): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

