// Package: jansi
package jansi

// Imports Begin
import std.collection.ArrayList
import std.io.OutputStream
// Imports End

public open class AnsiProcessor {
    // Fields Begin
    static let ERASE_SCREEN_TO_END: Int32 = throw Exception('TODO')
    static let ERASE_SCREEN_TO_BEGINING: Int32 = throw Exception('TODO')
    static let ERASE_SCREEN: Int32 = throw Exception('TODO')
    static let ERASE_LINE_TO_END: Int32 = throw Exception('TODO')
    static let ERASE_LINE_TO_BEGINING: Int32 = throw Exception('TODO')
    static let ERASE_LINE: Int32 = throw Exception('TODO')
    static let ATTRIBUTE_INTENSITY_BOLD: Int32 = throw Exception('TODO')
    static let ATTRIBUTE_INTENSITY_FAINT: Int32 = throw Exception('TODO')
    static let ATTRIBUTE_ITALIC: Int32 = throw Exception('TODO')
    static let ATTRIBUTE_UNDERLINE: Int32 = throw Exception('TODO')
    static let ATTRIBUTE_BLINK_SLOW: Int32 = throw Exception('TODO')
    static let ATTRIBUTE_BLINK_FAST: Int32 = throw Exception('TODO')
    static let ATTRIBUTE_NEGATIVE_ON: Int32 = throw Exception('TODO')
    static let ATTRIBUTE_CONCEAL_ON: Int32 = throw Exception('TODO')
    static let ATTRIBUTE_UNDERLINE_DOUBLE: Int32 = throw Exception('TODO')
    static let ATTRIBUTE_INTENSITY_NORMAL: Int32 = throw Exception('TODO')
    static let ATTRIBUTE_UNDERLINE_OFF: Int32 = throw Exception('TODO')
    static let ATTRIBUTE_BLINK_OFF: Int32 = throw Exception('TODO')
    static let ATTRIBUTE_NEGATIVE_OFF: Int32 = throw Exception('TODO')
    static let ATTRIBUTE_CONCEAL_OFF: Int32 = throw Exception('TODO')
    var os: OutputStream = throw Exception('TODO')
    static let BLACK: Int32 = throw Exception('TODO')
    static let RED: Int32 = throw Exception('TODO')
    static let GREEN: Int32 = throw Exception('TODO')
    static let YELLOW: Int32 = throw Exception('TODO')
    static let BLUE: Int32 = throw Exception('TODO')
    static let MAGENTA: Int32 = throw Exception('TODO')
    static let CYAN: Int32 = throw Exception('TODO')
    static let WHITE: Int32 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(os: OutputStream) {
        throw Exception('TODO')
    }

    protected open func getNextOptionInt<Object>(optionsIterator: Iterator<Any>): Int32 {
        throw Exception('TODO')
    }

    protected open func processEscapeCommand<Object>(options: ArrayList<Any>, command: Int32): Bool {
        throw Exception('TODO')
    }

    protected open func processOperatingSystemCommand<Object>(options: ArrayList<Any>): Bool {
        throw Exception('TODO')
    }

    protected open func processCharsetSelect<Object>(options: ArrayList<Any>): Bool {
        throw Exception('TODO')
    }

    private func optionInt<Object>(options: ArrayList<Any>, index: Int32): Int32 {
        throw Exception('TODO')
    }

    private func optionInt<Object>(options: ArrayList<Any>, index: Int32, defaultValue: Int32): Int32 {
        throw Exception('TODO')
    }

    protected open func processRestoreCursorPosition(): Unit {
        throw Exception('TODO')
    }

    protected open func processSaveCursorPosition(): Unit {
        throw Exception('TODO')
    }

    protected open func processInsertLine(optionInt: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processDeleteLine(optionInt: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processScrollDown(optionInt: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processScrollUp(optionInt: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processEraseScreen(eraseOption: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processEraseLine(eraseOption: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processSetAttribute(attribute: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processSetForegroundColor(color: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processSetForegroundColor(color: Int32, bright: Bool): Unit {
        throw Exception('TODO')
    }

    protected open func processSetForegroundColorExt(paletteIndex: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processSetForegroundColorExt(r: Int32, g: Int32, b: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processSetBackgroundColor(color: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processSetBackgroundColor(color: Int32, bright: Bool): Unit {
        throw Exception('TODO')
    }

    protected open func processSetBackgroundColorExt(paletteIndex: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processSetBackgroundColorExt(r: Int32, g: Int32, b: Int32): Unit {
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

    protected open func processCursorTo(row: Int32, col: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorToColumn(x: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorUpLine(count: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorDownLine(count: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorLeft(count: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorRight(count: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorDown(count: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processCursorUp(count: Int32): Unit {
        throw Exception('TODO')
    }

    protected open func processUnknownExtension<Object>(options: ArrayList<Any>, command: Int32): Unit {
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

    protected open func processUnknownOperatingSystemCommand(command: Int32, param: String): Unit {
        throw Exception('TODO')
    }

    protected open func processCharsetSelect(set: Int32, seq: Rune): Unit {
                // Method body intentionally left empty
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

