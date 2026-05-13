// Package: jansi
package jansi

// Imports Begin

// Imports End

public open class Kernel32 {
    // Fields Begin
    static var FOREGROUND_BLUE: Int16 = throw Exception('TODO')
    static var FOREGROUND_GREEN: Int16 = throw Exception('TODO')
    static var FOREGROUND_RED: Int16 = throw Exception('TODO')
    static var FOREGROUND_INTENSITY: Int16 = throw Exception('TODO')
    static var BACKGROUND_BLUE: Int16 = throw Exception('TODO')
    static var BACKGROUND_GREEN: Int16 = throw Exception('TODO')
    static var BACKGROUND_RED: Int16 = throw Exception('TODO')
    static var BACKGROUND_INTENSITY: Int16 = throw Exception('TODO')
    static var COMMON_LVB_LEADING_BYTE: Int16 = throw Exception('TODO')
    static var COMMON_LVB_TRAILING_BYTE: Int16 = throw Exception('TODO')
    static var COMMON_LVB_GRID_HORIZONTAL: Int16 = throw Exception('TODO')
    static var COMMON_LVB_GRID_LVERTICAL: Int16 = throw Exception('TODO')
    static var COMMON_LVB_GRID_RVERTICAL: Int16 = throw Exception('TODO')
    static var COMMON_LVB_REVERSE_VIDEO: Int16 = throw Exception('TODO')
    static var COMMON_LVB_UNDERSCORE: Int16 = throw Exception('TODO')
    static var FORMAT_MESSAGE_FROM_SYSTEM: Int64 = throw Exception('TODO')
    static var STD_INPUT_HANDLE: Int64 = throw Exception('TODO')
    static var STD_OUTPUT_HANDLE: Int64 = throw Exception('TODO')
    static var STD_ERROR_HANDLE: Int64 = throw Exception('TODO')
    static var INVALID_HANDLE_VALUE: Int64 = throw Exception('TODO')
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
        throw Exception('TODO')
    }

    public static func FormatMessageW(flags: Int64, source: Int64, messageId: Int64, languageId: Int64, buffer: Array<Byte>, size: Int64, args: Array<Int64>): Int64 {
        throw Exception('TODO')
    }

    public static func GetConsoleScreenBufferInfo(consoleOutput: Int64, consoleScreenBufferInfo: Kernel32_CONSOLE_SCREEN_BUFFER_INFO): Int64 {
        throw Exception('TODO')
    }

    public static func GetStdHandle(stdHandle: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func SetConsoleCursorPosition(consoleOutput: Int64, cursorPosition: Kernel32_COORD): Int64 {
        throw Exception('TODO')
    }

    public static func FillConsoleOutputCharacterW(consoleOutput: Int64, character: Rune, length: Int64, writeCoord: Kernel32_COORD, numberOfCharsWritten: Array<Int64>): Int64 {
        throw Exception('TODO')
    }

    public static func FillConsoleOutputAttribute(consoleOutput: Int64, attribute: Int16, length: Int64, writeCoord: Kernel32_COORD, numberOfAttrsWritten: Array<Int64>): Int64 {
        throw Exception('TODO')
    }

    public static func WriteConsoleW(consoleOutput: Int64, buffer: Array<UInt16>, numberOfCharsToWrite: Int64, numberOfCharsWritten: Array<Int64>, reserved: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func GetConsoleMode(handle: Int64, mode: Array<Int64>): Int64 {
        throw Exception('TODO')
    }

    public static func SetConsoleMode(handle: Int64, mode: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func _getch(): Int64 {
        throw Exception('TODO')
    }

    public static func SetConsoleTitle(title: String): Int64 {
        throw Exception('TODO')
    }

    public static func GetConsoleOutputCP(): Int64 {
        throw Exception('TODO')
    }

    public static func SetConsoleOutputCP(codePageID: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func ScrollConsoleScreenBuffer(consoleOutput: Int64, scrollRectangle: Kernel32_SMALL_RECT, clipRectangle: Kernel32_SMALL_RECT, destinationOrigin: Kernel32_COORD, fill: Kernel32_CHAR_INFO): Int64 {
        throw Exception('TODO')
    }

    private static func ReadConsoleInputW(handle: Int64, inputRecord: Int64, length: Int64, eventsCount: Array<Int64>): Int64 {
        throw Exception('TODO')
    }

    private static func PeekConsoleInputW(handle: Int64, inputRecord: Int64, length: Int64, eventsCount: Array<Int64>): Int64 {
        throw Exception('TODO')
    }

    public static func GetNumberOfConsoleInputEvents(handle: Int64, numberOfEvents: Array<Int64>): Int64 {
        throw Exception('TODO')
    }

    public static func FlushConsoleInputBuffer(handle: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func readConsoleInputHelper(handle: Int64, count: Int64, peek: Bool): Array<Kernel32_INPUT_RECORD> {
        throw Exception('TODO')
    }

    public static func readConsoleKeyInput(handle: Int64, count: Int64, peek: Bool): Array<Kernel32_INPUT_RECORD> {
        throw Exception('TODO')
    }

    public static func getLastErrorMessage(): String {
        throw Exception('TODO')
    }

    public static func getErrorMessage(errorCode: Int64): String {
        throw Exception('TODO')
    }

    // Methods End
}

public open class Kernel32_SMALL_RECT {
    // Fields Begin
    static var SIZEOF: Int64 = throw Exception('TODO')
    var left: Int16 = throw Exception('TODO')
    var top: Int16 = throw Exception('TODO')
    var right: Int16 = throw Exception('TODO')
    var bottom: Int16 = throw Exception('TODO')
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
        throw Exception('TODO')
    }

    public open func height(): Int16 {
        throw Exception('TODO')
    }

    public open func copy(): Kernel32_SMALL_RECT {
        throw Exception('TODO')
    }

    // Methods End
}

public open class Kernel32_COORD {
    // Fields Begin
    static var SIZEOF: Int64 = throw Exception('TODO')
    var x: Int16 = throw Exception('TODO')
    var y: Int16 = throw Exception('TODO')
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
    static var SIZEOF: Int64 = throw Exception('TODO')
    var size: Kernel32_COORD = throw Exception('TODO')
    var cursorPosition: Kernel32_COORD = throw Exception('TODO')
    var attributes: Int16 = throw Exception('TODO')
    var window: Kernel32_SMALL_RECT = throw Exception('TODO')
    var maximumWindowSize: Kernel32_COORD = throw Exception('TODO')
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
        throw Exception('TODO')
    }

    public open func windowHeight(): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

public open class Kernel32_CHAR_INFO {
    // Fields Begin
    static var SIZEOF: Int64 = throw Exception('TODO')
    var attributes: Int16 = throw Exception('TODO')
    var unicodeChar: Rune = throw Exception('TODO')
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
    static var SIZEOF: Int64 = throw Exception('TODO')
    static var CAPSLOCK_ON: Int64 = throw Exception('TODO')
    static var NUMLOCK_ON: Int64 = throw Exception('TODO')
    static var SCROLLLOCK_ON: Int64 = throw Exception('TODO')
    static var ENHANCED_KEY: Int64 = throw Exception('TODO')
    static var LEFT_ALT_PRESSED: Int64 = throw Exception('TODO')
    static var LEFT_CTRL_PRESSED: Int64 = throw Exception('TODO')
    static var RIGHT_ALT_PRESSED: Int64 = throw Exception('TODO')
    static var RIGHT_CTRL_PRESSED: Int64 = throw Exception('TODO')
    static var SHIFT_PRESSED: Int64 = throw Exception('TODO')
    var keyDown: Bool = throw Exception('TODO')
    var repeatCount: Int16 = throw Exception('TODO')
    var keyCode: Int16 = throw Exception('TODO')
    var scanCode: Int16 = throw Exception('TODO')
    var uchar: Rune = throw Exception('TODO')
    var controlKeyState: Int64 = throw Exception('TODO')
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

public open class Kernel32_MOUSE_EVENT_RECORD {
    // Fields Begin
    static var SIZEOF: Int64 = throw Exception('TODO')
    static var FROM_LEFT_1ST_BUTTON_PRESSED: Int64 = throw Exception('TODO')
    static var FROM_LEFT_2ND_BUTTON_PRESSED: Int64 = throw Exception('TODO')
    static var FROM_LEFT_3RD_BUTTON_PRESSED: Int64 = throw Exception('TODO')
    static var FROM_LEFT_4TH_BUTTON_PRESSED: Int64 = throw Exception('TODO')
    static var RIGHTMOST_BUTTON_PRESSED: Int64 = throw Exception('TODO')
    static var CAPSLOCK_ON: Int64 = throw Exception('TODO')
    static var NUMLOCK_ON: Int64 = throw Exception('TODO')
    static var SCROLLLOCK_ON: Int64 = throw Exception('TODO')
    static var ENHANCED_KEY: Int64 = throw Exception('TODO')
    static var LEFT_ALT_PRESSED: Int64 = throw Exception('TODO')
    static var LEFT_CTRL_PRESSED: Int64 = throw Exception('TODO')
    static var RIGHT_ALT_PRESSED: Int64 = throw Exception('TODO')
    static var RIGHT_CTRL_PRESSED: Int64 = throw Exception('TODO')
    static var SHIFT_PRESSED: Int64 = throw Exception('TODO')
    static var DOUBLE_CLICK: Int64 = throw Exception('TODO')
    static var MOUSE_HWHEELED: Int64 = throw Exception('TODO')
    static var MOUSE_MOVED: Int64 = throw Exception('TODO')
    static var MOUSE_WHEELED: Int64 = throw Exception('TODO')
    var mousePosition: Kernel32_COORD = throw Exception('TODO')
    var buttonState: Int64 = throw Exception('TODO')
    var controlKeyState: Int64 = throw Exception('TODO')
    var eventFlags: Int64 = throw Exception('TODO')
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
    static var SIZEOF: Int64 = throw Exception('TODO')
    var size: Kernel32_COORD = throw Exception('TODO')
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
    static var SIZEOF: Int64 = throw Exception('TODO')
    var setFocus: Bool = throw Exception('TODO')
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
    static var SIZEOF: Int64 = throw Exception('TODO')
    var commandId: Int64 = throw Exception('TODO')
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
    static var SIZEOF: Int64 = throw Exception('TODO')
    static var KEY_EVENT: Int16 = throw Exception('TODO')
    static var MOUSE_EVENT: Int16 = throw Exception('TODO')
    static var WINDOW_BUFFER_SIZE_EVENT: Int16 = throw Exception('TODO')
    static var FOCUS_EVENT: Int16 = throw Exception('TODO')
    static var MENU_EVENT: Int16 = throw Exception('TODO')
    var eventType: Int16 = throw Exception('TODO')
    var keyEvent: Kernel32_KEY_EVENT_RECORD = throw Exception('TODO')
    var mouseEvent: Kernel32_MOUSE_EVENT_RECORD = throw Exception('TODO')
    var windowBufferSizeEvent: Kernel32_WINDOW_BUFFER_SIZE_RECORD = throw Exception('TODO')
    var menuEvent: Kernel32_MENU_EVENT_RECORD = throw Exception('TODO')
    var focusEvent: Kernel32_FOCUS_EVENT_RECORD = throw Exception('TODO')
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
        throw Exception('TODO')
    }

    // Methods End
}

