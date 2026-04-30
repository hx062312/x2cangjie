// Package: jansi.io
package jansi.io

// Imports Begin
// Imports End

class AnsiProcessor {
    // Fields Begin
    static let ERASE_SCREEN_TO_END: Int64 = throw Exception('TODO')
    static let ERASE_SCREEN_TO_BEGINING: Int64 = throw Exception('TODO')
    static let ERASE_SCREEN: Int64 = throw Exception('TODO')
    static let ERASE_LINE_TO_END: Int64 = throw Exception('TODO')
    static let ERASE_LINE_TO_BEGINING: Int64 = throw Exception('TODO')
    static let ERASE_LINE: Int64 = throw Exception('TODO')
    static let ATTRIBUTE_INTENSITY_BOLD: Int64 = throw Exception('TODO')
    static let ATTRIBUTE_INTENSITY_FAINT: Int64 = throw Exception('TODO')
    static let ATTRIBUTE_ITALIC: Int64 = throw Exception('TODO')
    static let ATTRIBUTE_UNDERLINE: Int64 = throw Exception('TODO')
    static let ATTRIBUTE_BLINK_SLOW: Int64 = throw Exception('TODO')
    static let ATTRIBUTE_BLINK_FAST: Int64 = throw Exception('TODO')
    static let ATTRIBUTE_NEGATIVE_ON: Int64 = throw Exception('TODO')
    static let ATTRIBUTE_CONCEAL_ON: Int64 = throw Exception('TODO')
    static let ATTRIBUTE_UNDERLINE_DOUBLE: Int64 = throw Exception('TODO')
    static let ATTRIBUTE_INTENSITY_NORMAL: Int64 = throw Exception('TODO')
    static let ATTRIBUTE_UNDERLINE_OFF: Int64 = throw Exception('TODO')
    static let ATTRIBUTE_BLINK_OFF: Int64 = throw Exception('TODO')
    static let ATTRIBUTE_NEGATIVE_OFF: Int64 = throw Exception('TODO')
    static let ATTRIBUTE_CONCEAL_OFF: Int64 = throw Exception('TODO')
    let os: OutputStream = throw Exception('TODO')
    static let BLACK: Int64 = throw Exception('TODO')
    static let RED: Int64 = throw Exception('TODO')
    static let GREEN: Int64 = throw Exception('TODO')
    static let YELLOW: Int64 = throw Exception('TODO')
    static let BLUE: Int64 = throw Exception('TODO')
    static let MAGENTA: Int64 = throw Exception('TODO')
    static let CYAN: Int64 = throw Exception('TODO')
    static let WHITE: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(os: OutputStream) {
        throw Exception('TODO')
    }

    protected func getNextOptionInt(optionsIterator: Iterator<Any>): Int64 {
        throw Exception('TODO')
    }

    protected func processEscapeCommand(options: ArrayList<Any>, command: Int64): Bool {
        throw Exception('TODO')
    }

    protected func processOperatingSystemCommand(options: ArrayList<Any>): Bool {
        throw Exception('TODO')
    }

    protected func processRestoreCursorPosition(): Unit {
        throw Exception('TODO')
    }

    protected func processSaveCursorPosition(): Unit {
        throw Exception('TODO')
    }

    protected func processInsertLine(optionInt: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processDeleteLine(optionInt: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processScrollDown(optionInt: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processScrollUp(optionInt: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processEraseScreen(eraseOption: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processEraseLine(eraseOption: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processSetAttribute(attribute: Int64): Unit {
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

    protected func processUnknownExtension(options: ArrayList<Any>, command: Int64): Unit {
        throw Exception('TODO')
    }

    protected func processChangeIconNameAndWindowTitle(label: String): Unit {
        throw Exception('TODO')
    }

    protected func processChangeIconName(label: String): Unit {
        throw Exception('TODO')
    }

    protected func processChangeWindowTitle(label: String): Unit {
        throw Exception('TODO')
    }

    protected func processUnknownOperatingSystemCommand(command: Int64, param: String): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

