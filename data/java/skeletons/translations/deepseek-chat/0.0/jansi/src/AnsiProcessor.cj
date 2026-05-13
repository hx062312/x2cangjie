// Package: jansi
package jansi

// Imports Begin
import std.collection.ArrayList
import std.io.OutputStream
// Imports End

public open class AnsiProcessor {
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

    protected open func getNextOptionInt(optionsIterator: Iterator<Any>): Int64 {
        throw Exception('TODO')
    }

    protected open func processEscapeCommand(options: ArrayList<Any>, command: Int64): Bool {
        throw Exception('TODO')
    }

    protected open func processOperatingSystemCommand(options: ArrayList<Any>): Bool {
        throw Exception('TODO')
    }

    protected open func processCharsetSelect(options: ArrayList<Any>): Bool {
        throw Exception('TODO')
    }

    private func optionInt(options: ArrayList<Any>, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private func optionInt(options: ArrayList<Any>, index: Int64, defaultValue: Int64): Int64 {
        throw Exception('TODO')
    }

    protected open func processRestoreCursorPosition(): Unit {
        throw Exception('TODO')
    }

    protected open func processSaveCursorPosition(): Unit {
        throw Exception('TODO')
    }

    protected open func processInsertLine(optionInt: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processDeleteLine(optionInt: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processScrollDown(optionInt: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processScrollUp(optionInt: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processEraseScreen(eraseOption: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processEraseLine(eraseOption: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processSetAttribute(attribute: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processSetForegroundColor(color: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processSetForegroundColor(color: Int64, bright: Bool): Unit {
        throw Exception('TODO')
    }

    protected open func processSetForegroundColorExt(paletteIndex: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processSetForegroundColorExt(r: Int64, g: Int64, b: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processSetBackgroundColor(color: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processSetBackgroundColor(color: Int64, bright: Bool): Unit {
        throw Exception('TODO')
    }

    protected open func processSetBackgroundColorExt(paletteIndex: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processSetBackgroundColorExt(r: Int64, g: Int64, b: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processDefaultTextColor(): Unit {
        throw Exception('TODO')
    }

    protected open func processDefaultBackgroundColor(): Unit {
        throw Exception('TODO')
    }

    protected open func processAttributeReset(): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorTo(row: Int64, col: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorToColumn(x: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorUpLine(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorDownLine(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorLeft(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorRight(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorDown(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorUp(count: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processUnknownExtension(options: ArrayList<Any>, command: Int64): Unit {
        throw Exception('TODO')
    }

    protected open func processChangeIconNameAndWindowTitle(label: String): Unit {
        throw Exception('TODO')
    }

    protected open func processChangeIconName(label: String): Unit {
        throw Exception('TODO')
    }

    protected open func processChangeWindowTitle(label: String): Unit {
        throw Exception('TODO')
    }

    protected open func processUnknownOperatingSystemCommand(command: Int64, param: String): Unit {
        throw Exception('TODO')
    }

    protected open func processCharsetSelect(set: Int64, seq: Rune): Unit {
        throw Exception('TODO')
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

