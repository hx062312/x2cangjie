// Package: jansi.io
package jansi.io

// Imports Begin
import std.io.OutputStream
// Imports End

public class WindowsAnsiProcessor <: AnsiProcessor {
    // Fields Begin
    let console: Int64 = throw Exception('TODO')
    static let FOREGROUND_BLACK: Int16 = throw Exception('TODO')
    static let FOREGROUND_YELLOW: Int16 = throw Exception('TODO')
    static let FOREGROUND_MAGENTA: Int16 = throw Exception('TODO')
    static let FOREGROUND_CYAN: Int16 = throw Exception('TODO')
    static let FOREGROUND_WHITE: Int16 = throw Exception('TODO')
    static let BACKGROUND_BLACK: Int16 = throw Exception('TODO')
    static let BACKGROUND_YELLOW: Int16 = throw Exception('TODO')
    static let BACKGROUND_MAGENTA: Int16 = throw Exception('TODO')
    static let BACKGROUND_CYAN: Int16 = throw Exception('TODO')
    static let BACKGROUND_WHITE: Int16 = throw Exception('TODO')
    static let ANSI_FOREGROUND_COLOR_MAP: Array<Int16> = throw Exception('TODO')
    static let ANSI_BACKGROUND_COLOR_MAP: Array<Int16> = throw Exception('TODO')
    let info: Kernel32_CONSOLE_SCREEN_BUFFER_INFO = throw Exception('TODO')
    let originalColors: Int16 = throw Exception('TODO')
    var negative: Bool = throw Exception('TODO')
    var savedX: Int16 = throw Exception('TODO')
    var savedY: Int16 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(ps: OutputStream, console: Int64) {
        super()
        throw Exception('TODO')
    }

    public init(ps: OutputStream, stdout: Bool) {
        super()
        throw Exception('TODO')
    }

    public init(ps: OutputStream) {
        super()
        throw Exception('TODO')
    }

    private func getConsoleInfo(): Unit {
        throw Exception('TODO')
    }

    private func applyAttribute(): Unit {
        throw Exception('TODO')
    }

    private func invertAttributeColors(attributes: Int16): Int16 {
        throw Exception('TODO')
    }

    private func applyCursorPosition(): Unit {
        throw Exception('TODO')
    }

    protected override func processEraseScreen(eraseOption: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processEraseLine(eraseOption: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processCursorLeft(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processCursorRight(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processCursorDown(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected override func processCursorUp(count: Int64): Unit {
        throw Exception('TODO')
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

    protected init() {
        throw Exception('TODO')
    }
}

