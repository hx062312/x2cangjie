// Package: jansi.io
package jansi.io

// Imports Begin
// Imports End

class WindowsAnsiProcessor <: AnsiProcessor {
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
    let info: Any = throw Exception('TODO')
    let originalColors: Int16 = throw Exception('TODO')
    var negative: Bool = throw Exception('TODO')
    var savedX: Int16 = throw Exception('TODO')
    var savedY: Int16 = throw Exception('TODO')
    // Fields End

    // Methods Begin
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

    protected func processEraseScreen(eraseOption: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processEraseLine(eraseOption: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processCursorLeft(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processCursorRight(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processCursorDown(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processCursorUp(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processCursorTo(row: Int64, col: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processCursorToColumn(x: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processCursorUpLine(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processCursorDownLine(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processSetForegroundColor(color: Int64, bright: Bool): Unit {
        throw Exception('TODO')
    }

    protected func processSetBackgroundColor(color: Int64, bright: Bool): Unit {
        throw Exception('TODO')
    }

    protected func processDefaultTextColor(): Unit {
        throw Exception('TODO')
    }

    protected func processDefaultBackgroundColor(): Unit {
        throw Exception('TODO')
    }

    protected func processAttributeReset(): Unit {
        throw Exception('TODO')
    }

    protected func processSetAttribute(attribute: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processSaveCursorPosition(): Unit {
        throw Exception('TODO')
    }

    protected func processRestoreCursorPosition(): Unit {
        throw Exception('TODO')
    }

    protected func processInsertLine(optionInt: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processDeleteLine(optionInt: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processChangeWindowTitle(label: String): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

