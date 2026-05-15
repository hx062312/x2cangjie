// Package: jansi
package jansi

// Imports Begin
import std.collection.ArrayList
import std.io.OutputStream
// Imports End

public open class AnsiProcessor {
    // Fields Begin
    static let ERASE_SCREEN_TO_END: Int64 = 0
    static let ERASE_SCREEN_TO_BEGINING: Int64 = 1
    static let ERASE_SCREEN: Int64 = 2
    static let ERASE_LINE_TO_END: Int64 = 0
    static let ERASE_LINE_TO_BEGINING: Int64 = 1
    static let ERASE_LINE: Int64 = 2
    static let ATTRIBUTE_INTENSITY_BOLD: Int64 = 1
    static let ATTRIBUTE_INTENSITY_FAINT: Int64 = 2
    static let ATTRIBUTE_ITALIC: Int64 = 3
    static let ATTRIBUTE_UNDERLINE: Int64 = 4
    static let ATTRIBUTE_BLINK_SLOW: Int64 = 5
    static let ATTRIBUTE_BLINK_FAST: Int64 = 6
    static let ATTRIBUTE_NEGATIVE_ON: Int64 = 7
    static let ATTRIBUTE_CONCEAL_ON: Int64 = 8
    static let ATTRIBUTE_UNDERLINE_DOUBLE: Int64 = 21
    static let ATTRIBUTE_INTENSITY_NORMAL: Int64 = 22
    static let ATTRIBUTE_UNDERLINE_OFF: Int64 = 24
    static let ATTRIBUTE_BLINK_OFF: Int64 = 25
    static let ATTRIBUTE_NEGATIVE_OFF: Int64 = 27
    static let ATTRIBUTE_CONCEAL_OFF: Int64 = 28
    let os: OutputStream = throw Exception('TODO')
    static let BLACK: Int64 = 0
    static let RED: Int64 = 1
    static let GREEN: Int64 = 2
    static let YELLOW: Int64 = 3
    static let BLUE: Int64 = 4
    static let MAGENTA: Int64 = 5
    static let CYAN: Int64 = 6
    static let WHITE: Int64 = 7
    // Fields End

    // Methods Begin
    public init(os: OutputStream) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected open func getNextOptionInt(optionsIterator: Iterator<Object>): Int64 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected open func processEscapeCommand(options: ArrayList<Object>, command: Int64): Bool {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected open func processOperatingSystemCommand(options: ArrayList<Object>): Bool {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected open func processCharsetSelect(options: ArrayList<Object>): Bool {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func optionInt(options: ArrayList<Object>, index: Int64): Int64 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func optionInt(options: ArrayList<Object>, index: Int64, defaultValue: Int64): Int64 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected open func processRestoreCursorPosition(): Unit {
                                throw Exception('TODO')
    }

    protected open func processSaveCursorPosition(): Unit {
                os.write(27);
        os.write(91);
        os.write(115);
    }

    protected open func processInsertLine(optionInt: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processDeleteLine(optionInt: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processScrollDown(optionInt: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processScrollUp(optionInt: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processEraseScreen(eraseOption: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processEraseLine(eraseOption: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processSetAttribute(attribute: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processSetForegroundColor(color: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected open func processSetForegroundColor(color: Int64, bright: Bool): Unit {
                throw Exception("TODO")
    }

    protected open func processSetForegroundColorExt(paletteIndex: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected open func processSetForegroundColorExt(r: Int64, g: Int64, b: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processSetBackgroundColor(color: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected open func processSetBackgroundColor(color: Int64, bright: Bool): Unit {
                throw Exception("TODO")
    }

    protected open func processSetBackgroundColorExt(paletteIndex: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected open func processSetBackgroundColorExt(r: Int64, g: Int64, b: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processDefaultTextColor(): Unit {
                throw Exception("TODO")
    }

    protected open func processDefaultBackgroundColor(): Unit {
                throw Exception("TODO")
    }

    protected open func processAttributeReset(): Unit {
                throw Exception("TODO")
    }

    protected open func processCursorTo(row: Int64, col: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processCursorToColumn(x: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processCursorUpLine(count: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processCursorDownLine(count: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected open func processCursorLeft(count: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processCursorRight(count: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected open func processCursorDown(count: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processCursorUp(count: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processUnknownExtension(options: ArrayList<Object>, command: Int64): Unit {
                throw Exception("TODO")
    }

    protected open func processChangeIconNameAndWindowTitle(label: String): Unit {
                processChangeIconName(label)
        processChangeWindowTitle(label)
    }

    protected open func processChangeIconName(label: String): Unit {
                throw Exception("TODO")
    }

    protected open func processChangeWindowTitle(label: String): Unit {
                throw Exception("TODO")
    }

    protected open func processUnknownOperatingSystemCommand(command: Int64, param: String): Unit {
                throw Exception("TODO")
    }

    protected open func processCharsetSelect(set: Int64, seq: Rune): Unit {
                throw Exception("TODO")
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

