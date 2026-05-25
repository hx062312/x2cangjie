// Package: jansi
package jansi

// Imports Begin
import std.io.*
import std.io.OutputStream
// Imports End

public class WindowsAnsiProcessor <: AnsiProcessor {
    // Fields Begin
    let console: Int64 = throw Exception('TODO')
    static let FOREGROUND_BLACK: Int16 = throw Exception('TODO')
    static let FOREGROUND_YELLOW: Int16 = Kernel32.FOREGROUND_RED | Kernel32.FOREGROUND_GREEN
    static let FOREGROUND_MAGENTA: Int16 = Kernel32.FOREGROUND_BLUE | Kernel32.FOREGROUND_RED
    static let FOREGROUND_CYAN: Int16 = Kernel32.FOREGROUND_BLUE | Kernel32.FOREGROUND_GREEN
    static let FOREGROUND_WHITE: Int16 = Kernel32.FOREGROUND_RED | Kernel32.FOREGROUND_GREEN | Kernel32.FOREGROUND_BLUE
    static let BACKGROUND_BLACK: Int16 = throw Exception('TODO')
    static let BACKGROUND_YELLOW: Int16 = throw Exception('TODO')  // Already translated, compilation failed
    static let BACKGROUND_MAGENTA: Int16 = throw Exception('TODO')  // Already translated, compilation failed
    static let BACKGROUND_CYAN: Int16 = Kernel32.BACKGROUND_BLUE | Kernel32.BACKGROUND_GREEN
    static let BACKGROUND_WHITE: Int16 = Kernel32.BACKGROUND_RED | Kernel32.BACKGROUND_GREEN | Kernel32.BACKGROUND_BLUE
    static let ANSI_FOREGROUND_COLOR_MAP: Array<Int16> = [FOREGROUND_BLACK, Kernel32.FOREGROUND_RED, Kernel32.FOREGROUND_GREEN, FOREGROUND_YELLOW, Kernel32.FOREGROUND_BLUE, FOREGROUND_MAGENTA, FOREGROUND_CYAN, FOREGROUND_WHITE]
    static let ANSI_BACKGROUND_COLOR_MAP: Array<Int16> = [BACKGROUND_BLACK, Kernel32.BACKGROUND_RED, Kernel32.BACKGROUND_GREEN, BACKGROUND_YELLOW, Kernel32.BACKGROUND_BLUE, BACKGROUND_MAGENTA, BACKGROUND_CYAN, BACKGROUND_WHITE]
    let info: Kernel32_CONSOLE_SCREEN_BUFFER_INFO = Kernel32_CONSOLE_SCREEN_BUFFER_INFO()
    let originalColors: Int16 = throw Exception('TODO')
    var negative: Bool = false
    var savedX: Int16 = -1
    var savedY: Int16 = -1
    // Fields End

    // Methods Begin
    public init(ps: OutputStream, console: Int64) {
        super()
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func WindowsAnsiProcessor0(ps: OutputStream, stdout: Bool): WindowsAnsiProcessor {
                return WindowsAnsiProcessor(ps, Kernel32.GetStdHandle(if (stdout) { Kernel32.STD_OUTPUT_HANDLE } else { Kernel32.STD_ERROR_HANDLE }))
    }

    public open func WindowsAnsiProcessor1(ps: OutputStream): WindowsAnsiProcessor {
                return WindowsAnsiProcessor0(ps, true)
    }

    private func getConsoleInfo(): Unit {
                os.flush()
        if (Kernel32.GetConsoleScreenBufferInfo(console, info) == 0) {
        throw IOException("Could not get the screen info: " + Kernel32.getLastErrorMessage())
        }
        if (negative) {
        info.attributes = invertAttributeColors(info.attributes)
        }
    }

    private func applyAttribute(): Unit {
                os.flush()
        var attributes: Int16 = info.attributes
        if (negative) {
        attributes = invertAttributeColors(attributes)
        }
        if (Kernel32.SetConsoleTextAttribute(console, attributes) == 0) {
        throw IOException(Kernel32.getLastErrorMessage())
        }
    }

    private func invertAttributeColors(attributes: Int16): Int16 {
                var fg: Int64 = Int64(0x000F & attributes)
        fg <<= 4
        var bg: Int64 = Int64(0x00F0 & attributes)
        bg >>= 4
        let result: Int16 = Int16((Int64(attributes) & 0xFF00) | fg | bg)
        return result
    }

    private func applyCursorPosition(): Unit {
                if (Kernel32.SetConsoleCursorPosition(console, info.cursorPosition.copy()) == 0) {
        throw IOException(Kernel32.getLastErrorMessage())
        }
    }

    protected override func processEraseScreen(eraseOption: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processEraseLine(eraseOption: Int64): Unit {
                getConsoleInfo()
        let written: Array<Int32> = Array<Int32>(1, repeat: 0)
        if (eraseOption == ERASE_LINE) {
        let leftColCurrRow: Kernel32_COORD = info.cursorPosition.copy()
        leftColCurrRow.x = 0
        Kernel32.FillConsoleOutputAttribute(console, info.attributes, info.size.x.position(), leftColCurrRow, written)
        Kernel32.FillConsoleOutputCharacterW(console, r' ', info.size.x.position(), leftColCurrRow, written)
        } else if (eraseOption == ERASE_LINE_TO_BEGINING) {
        let leftColCurrRow2: Kernel32_COORD = info.cursorPosition.copy()
        leftColCurrRow2.x = 0
        Kernel32.FillConsoleOutputAttribute(console, info.attributes, info.cursorPosition.x.position(), leftColCurrRow2, written)
        Kernel32.FillConsoleOutputCharacterW(console, r' ', info.cursorPosition.x.position(), leftColCurrRow2, written)
        } else if (eraseOption == ERASE_LINE_TO_END) {
        let lengthToLastCol: Int64 = info.size.x.position() - info.cursorPosition.x.position()
        Kernel32.FillConsoleOutputAttribute(console, info.attributes, lengthToLastCol, info.cursorPosition.copy(), written)
        Kernel32.FillConsoleOutputCharacterW(console, r' ', lengthToLastCol, info.cursorPosition.copy(), written)
        }
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
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processCursorToColumn(x: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processCursorUpLine(count: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processCursorDownLine(count: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processSetForegroundColor1(color: Int64, bright: Bool): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processSetForegroundColorExt0(paletteIndex: Int64): Unit {
                let round = Colors.roundColor0(paletteIndex, 16)
        if (round >= 8) {
        processSetForegroundColor1(round - 8, true)
        } else {
        processSetForegroundColor1(round, false)
        }
    }

    protected override func processSetForegroundColorExt1(r: Int64, g: Int64, b: Int64): Unit {
                let round = Colors.roundRgbColor(r, g, b, 16)
        if (round >= 8) {
        processSetForegroundColor1(round - 8, true)
        } else {
        processSetForegroundColor1(round, false)
        }
    }

    protected override func processSetBackgroundColor1(color: Int64, bright: Bool): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processSetBackgroundColorExt0(paletteIndex: Int64): Unit {
                let round = Colors.roundColor0(paletteIndex, 16)
        processSetBackgroundColor1(if (round >= 8) { round - 8 } else { round }, round >= 8)
    }

    protected override func processSetBackgroundColorExt1(r: Int64, g: Int64, b: Int64): Unit {
                let round = Colors.roundRgbColor(r, g, b, 16)
        if (round >= 8) {
        processSetBackgroundColor1(round - 8, true)
        } else {
        processSetBackgroundColor1(round, false)
        }
    }

    protected override func processDefaultTextColor(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processDefaultBackgroundColor(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processAttributeReset(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processSetAttribute(attribute: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processSaveCursorPosition(): Unit {
                getConsoleInfo()
        savedX = info.cursorPosition.x
        savedY = info.cursorPosition.y
    }

    protected override func processRestoreCursorPosition(): Unit {
                if (savedX != -1 && savedY != -1) {
        os.flush()
        info.cursorPosition.x = savedX
        info.cursorPosition.y = savedY
        applyCursorPosition()
        }
    }

    protected override func processInsertLine(optionInt: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processDeleteLine(optionInt: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processChangeWindowTitle(label: String): Unit {
                Kernel32.SetConsoleTitle(label)
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

