// Package: jansi
package jansi

// Imports Begin
import std.core.*
// Imports End

public open class Kernel32 {
    // Fields Begin
    static var FOREGROUND_BLUE: Int16 = 0
    static var FOREGROUND_GREEN: Int16 = 0
    static var FOREGROUND_RED: Int16 = 0
    static var FOREGROUND_INTENSITY: Int16 = 0
    static var BACKGROUND_BLUE: Int16 = 0
    static var BACKGROUND_GREEN: Int16 = 0
    static var BACKGROUND_RED: Int16 = 0
    static var BACKGROUND_INTENSITY: Int16 = throw Exception('TODO')
    static var COMMON_LVB_LEADING_BYTE: Int16 = 0
    static var COMMON_LVB_TRAILING_BYTE: Int16 = 0
    static var COMMON_LVB_GRID_HORIZONTAL: Int16 = throw Exception('TODO')
    static var COMMON_LVB_GRID_LVERTICAL: Int16 = 0
    static var COMMON_LVB_GRID_RVERTICAL: Int16 = 0
    static var COMMON_LVB_REVERSE_VIDEO: Int16 = 0
    static var COMMON_LVB_UNDERSCORE: Int16 = 0
    static var FORMAT_MESSAGE_FROM_SYSTEM: Int64 = 0
    static var STD_INPUT_HANDLE: Int64 = -10
    static var STD_OUTPUT_HANDLE: Int64 = -11
    static var STD_ERROR_HANDLE: Int64 = throw Exception('TODO')
    static var INVALID_HANDLE_VALUE: Int64 = -1
    // Fields End

    // Static Initializer Begin
    static init() {
                JansiLoader.initialize()
        init_()
    }

    // Static Initializer End

    // Methods Begin
    private static func init_(): Unit {
                // TODO: implement native method
    }

    public static func malloc(size: Int64): Int64 {
                throw Exception('TODO')
    }

    public static func free(ptr: Int64): Unit {
                throw Exception('TODO')
    }

    public static func SetConsoleTextAttribute(consoleOutput: Int64, attributes: Int16): Int64 {
                throw Exception('TODO')
    }

    public static func WaitForSingleObject(hHandle: Int64, dwMilliseconds: Int64): Int64 {
                throw Exception('TODO')
    }

    public static func CloseHandle(handle: Int64): Int64 {
                throw Exception('TODO')
    }

    public static func GetLastError(): Int64 {
                return 0
    }

    public static func FormatMessageW(flags: Int64, source: Int64, messageId: Int64, languageId: Int64, buffer: Array<Byte>, size: Int64, args: Array<Any>): Int64 {
                throw Exception('TODO')
    }

    public static func GetConsoleScreenBufferInfo(consoleOutput: Int64, consoleScreenBufferInfo: Kernel32_CONSOLE_SCREEN_BUFFER_INFO): Int64 {
                throw Exception("TODO")
    }

    public static func GetStdHandle(stdHandle: Int64): Int64 {
                throw Exception('TODO')
    }

    public static func SetConsoleCursorPosition(consoleOutput: Int64, cursorPosition: Kernel32_COORD): Int64 {
                throw Exception('TODO')
    }

    public static func FillConsoleOutputCharacterW(consoleOutput: Int64, character: Rune, length: Int64, writeCoord: Kernel32_COORD, numberOfCharsWritten: Array<Int32>): Int64 {
                throw Exception('TODO')
    }

    public static func FillConsoleOutputAttribute(consoleOutput: Int64, attribute: Int16, length: Int64, writeCoord: Kernel32_COORD, numberOfAttrsWritten: Array<Int32>): Int64 {
                throw Exception("TODO")
    }

    public static func WriteConsoleW(consoleOutput: Int64, buffer: Array<Rune>, numberOfCharsToWrite: Int64, numberOfCharsWritten: Array<Int32>, reserved: Int64): Int64 {
                throw Exception('TODO')
    }

    public static func GetConsoleMode(handle: Int64, mode: Array<Int32>): Int64 {
                throw Exception('TODO')
    }

    public static func SetConsoleMode(handle: Int64, mode: Int64): Int64 {
                throw Exception('TODO')
    }

    public static func _getch(): Int64 {
                throw Exception('TODO')
    }

    public static func SetConsoleTitle(title: String): Int64 {
                // Native method call - requires JNI or FFI binding
        throw Exception('Not implemented')
    }

    public static func GetConsoleOutputCP(): Int64 {
                throw Exception("TODO")
    }

    public static func SetConsoleOutputCP(codePageID: Int64): Int64 {
                throw Exception('TODO')
    }

    public static func ScrollConsoleScreenBuffer(consoleOutput: Int64, scrollRectangle: Kernel32_SMALL_RECT, clipRectangle: Kernel32_SMALL_RECT, destinationOrigin: Kernel32_COORD, fill: Kernel32_CHAR_INFO): Int64 {
                throw Exception("TODO")
    }

    private static func ReadConsoleInputW(handle: Int64, inputRecord: Int64, length: Int64, eventsCount: Array<Int32>): Int64 {
                throw Exception("TODO")
    }

    private static func PeekConsoleInputW(handle: Int64, inputRecord: Int64, length: Int64, eventsCount: Array<Int32>): Int64 {
                throw Exception('TODO')
    }

    public static func GetNumberOfConsoleInputEvents(handle: Int64, numberOfEvents: Array<Int32>): Int64 {
                throw Exception("TODO")
    }

    public static func FlushConsoleInputBuffer(handle: Int64): Int64 {
                throw Exception('TODO')
    }

    public static func readConsoleInputHelper(handle: Int64, count: Int64, peek: Bool): Array<Kernel32_INPUT_RECORD> {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func readConsoleKeyInput(handle: Int64, count: Int64, peek: Bool): Array<Kernel32_INPUT_RECORD> {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func getLastErrorMessage(): String {
                let errorCode = GetLastError()
        return getErrorMessage(errorCode)
    }

    public static func getErrorMessage(errorCode: Int64): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    // Methods End
}

public open class Kernel32_SMALL_RECT {
    // Fields Begin
    static var SIZEOF: Int64 = 0
    var left: Int16 = 0
    var top: Int16 = 0
    var right: Int16 = 0
    var bottom: Int16 = 0
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    private static func init_(): Unit {
        throw Exception('TODO')
    }

    public open func width(): Int16 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func height(): Int16 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func copy(): Kernel32_SMALL_RECT {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    // Methods End
}

public open class Kernel32_COORD {
    // Fields Begin
    static var SIZEOF: Int64 = 0
    var x: Int16 = 0
    var y: Int16 = 0
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    private static func init_(): Unit {
        throw Exception('TODO')
    }

    public open func copy(): Kernel32_COORD {
        throw Exception('TODO')
    }

    // Methods End
}

public open class Kernel32_CONSOLE_SCREEN_BUFFER_INFO {
    // Fields Begin
    static var SIZEOF: Int64 = 0
    var size: Kernel32_COORD = Kernel32_COORD()
    var cursorPosition: Kernel32_COORD = Kernel32_COORD()
    var attributes: Int16 = 0
    var window: Kernel32_SMALL_RECT = Kernel32_SMALL_RECT()
    var maximumWindowSize: Kernel32_COORD = Kernel32_COORD()
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    private static func init_(): Unit {
        throw Exception('TODO')
    }

    public open func windowWidth(): Int64 {
                return Int64(window.width()) + 1
    }

    public open func windowHeight(): Int64 {
                return Int64(window.height()) + 1
    }

    // Methods End
}

public open class Kernel32_CHAR_INFO {
    // Fields Begin
    static var SIZEOF: Int64 = 0
    var attributes: Int16 = 0
    var unicodeChar: Rune = '\0'
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    private static func init_(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

public open class Kernel32_KEY_EVENT_RECORD {
    // Fields Begin
    static var SIZEOF: Int64 = 0
    static var CAPSLOCK_ON: Int64 = 0
    static var NUMLOCK_ON: Int64 = 0
    static var SCROLLLOCK_ON: Int64 = 0
    static var ENHANCED_KEY: Int64 = 0
    static var LEFT_ALT_PRESSED: Int64 = 0
    static var LEFT_CTRL_PRESSED: Int64 = 0
    static var RIGHT_ALT_PRESSED: Int64 = 0
    static var RIGHT_CTRL_PRESSED: Int64 = 0
    static var SHIFT_PRESSED: Int64 = 0
    var keyDown: Bool = false
    var repeatCount: Int16 = 0
    var keyCode: Int16 = 0
    var scanCode: Int16 = 0
    var uchar: Rune = '\0'
    var controlKeyState: Int64 = 0
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    private static func init_(): Unit {
        throw Exception('TODO')
    }

    public open func toString(): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    // Methods End
}

public open class Kernel32_MOUSE_EVENT_RECORD {
    // Fields Begin
    static var SIZEOF: Int64 = 0
    static var FROM_LEFT_1ST_BUTTON_PRESSED: Int64 = 0
    static var FROM_LEFT_2ND_BUTTON_PRESSED: Int64 = 0
    static var FROM_LEFT_3RD_BUTTON_PRESSED: Int64 = 0
    static var FROM_LEFT_4TH_BUTTON_PRESSED: Int64 = 0
    static var RIGHTMOST_BUTTON_PRESSED: Int64 = 0
    static var CAPSLOCK_ON: Int64 = 0
    static var NUMLOCK_ON: Int64 = 0
    static var SCROLLLOCK_ON: Int64 = 0
    static var ENHANCED_KEY: Int64 = 0
    static var LEFT_ALT_PRESSED: Int64 = 0
    static var LEFT_CTRL_PRESSED: Int64 = 0
    static var RIGHT_ALT_PRESSED: Int64 = 0
    static var RIGHT_CTRL_PRESSED: Int64 = 0
    static var SHIFT_PRESSED: Int64 = 0
    static var DOUBLE_CLICK: Int64 = 0
    static var MOUSE_HWHEELED: Int64 = 0
    static var MOUSE_MOVED: Int64 = 0
    static var MOUSE_WHEELED: Int64 = 0
    var mousePosition: Kernel32_COORD = Kernel32_COORD()
    var buttonState: Int64 = 0
    var controlKeyState: Int64 = 0
    var eventFlags: Int64 = 0
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    private static func init_(): Unit {
        throw Exception('TODO')
    }

    public open func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

public open class Kernel32_WINDOW_BUFFER_SIZE_RECORD {
    // Fields Begin
    static var SIZEOF: Int64 = 0
    var size: Kernel32_COORD = Kernel32_COORD()
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    private static func init_(): Unit {
        throw Exception('TODO')
    }

    public open func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

public open class Kernel32_FOCUS_EVENT_RECORD {
    // Fields Begin
    static var SIZEOF: Int64 = 0
    var setFocus: Bool = false
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    private static func init_(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

public open class Kernel32_MENU_EVENT_RECORD {
    // Fields Begin
    static var SIZEOF: Int64 = 0
    var commandId: Int64 = 0
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    private static func init_(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

public open class Kernel32_INPUT_RECORD {
    // Fields Begin
    static var SIZEOF: Int64 = 0
    static var KEY_EVENT: Int16 = 0
    static var MOUSE_EVENT: Int16 = 0
    static var WINDOW_BUFFER_SIZE_EVENT: Int16 = 0
    static var FOCUS_EVENT: Int16 = 0
    static var MENU_EVENT: Int16 = 0
    var eventType: Int16 = 0
    var keyEvent: Kernel32_KEY_EVENT_RECORD = Kernel32_KEY_EVENT_RECORD()
    var mouseEvent: Kernel32_MOUSE_EVENT_RECORD = Kernel32_MOUSE_EVENT_RECORD()
    var windowBufferSizeEvent: Kernel32_WINDOW_BUFFER_SIZE_RECORD = Kernel32_WINDOW_BUFFER_SIZE_RECORD()
    var menuEvent: Kernel32_MENU_EVENT_RECORD = Kernel32_MENU_EVENT_RECORD()
    var focusEvent: Kernel32_FOCUS_EVENT_RECORD = Kernel32_FOCUS_EVENT_RECORD()
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    private static func init_(): Unit {
        throw Exception('TODO')
    }

    public static func memmove(dest: Kernel32_INPUT_RECORD, src: Int64, size: Int64): Unit {
                throw Exception("TODO")
    }

    // Methods End
}

