// Package: jansi
package jansi

// Imports Begin
// Imports End

class Ansi <: Appendable {
    // Fields Begin
    static let DISABLE: String = throw Exception('TODO')
    static var detector: Callable<Bool> = throw Exception('TODO')
    static let holder: InheritableThreadLocal<Bool> = throw Exception('TODO')
    static let FIRST_ESC_CHAR: Rune = throw Exception('TODO')
    static let SECOND_ESC_CHAR: Rune = throw Exception('TODO')
    let builder: Any = throw Exception('TODO')
    let attributeOptions: ArrayList<Int64> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func setDetector(detector: Callable<Bool>): Unit {
        throw Exception('TODO')
    }

    public static func isDetected(): Bool {
        throw Exception('TODO')
    }

    public static func setEnabled(flag: Bool): Unit {
        throw Exception('TODO')
    }

    public static func isEnabled(): Bool {
        throw Exception('TODO')
    }

    public func fgBlack(): Any {
        throw Exception('TODO')
    }

    public func fgBlue(): Any {
        throw Exception('TODO')
    }

    public func fgCyan(): Any {
        throw Exception('TODO')
    }

    public func fgDefault(): Any {
        throw Exception('TODO')
    }

    public func fgGreen(): Any {
        throw Exception('TODO')
    }

    public func fgMagenta(): Any {
        throw Exception('TODO')
    }

    public func fgRed(): Any {
        throw Exception('TODO')
    }

    public func fgYellow(): Any {
        throw Exception('TODO')
    }

    public func bgCyan(): Any {
        throw Exception('TODO')
    }

    public func bgDefault(): Any {
        throw Exception('TODO')
    }

    public func bgGreen(): Any {
        throw Exception('TODO')
    }

    public func bgMagenta(): Any {
        throw Exception('TODO')
    }

    public func bgRed(): Any {
        throw Exception('TODO')
    }

    public func bgYellow(): Any {
        throw Exception('TODO')
    }

    public func fgBright(color: Any): Any {
        throw Exception('TODO')
    }

    public func fgBrightBlack(): Any {
        throw Exception('TODO')
    }

    public func fgBrightBlue(): Any {
        throw Exception('TODO')
    }

    public func fgBrightCyan(): Any {
        throw Exception('TODO')
    }

    public func fgBrightDefault(): Any {
        throw Exception('TODO')
    }

    public func fgBrightGreen(): Any {
        throw Exception('TODO')
    }

    public func fgBrightMagenta(): Any {
        throw Exception('TODO')
    }

    public func fgBrightRed(): Any {
        throw Exception('TODO')
    }

    public func fgBrightYellow(): Any {
        throw Exception('TODO')
    }

    public func bgBright(color: Any): Any {
        throw Exception('TODO')
    }

    public func bgBrightCyan(): Any {
        throw Exception('TODO')
    }

    public func bgBrightDefault(): Any {
        throw Exception('TODO')
    }

    public func bgBrightGreen(): Any {
        throw Exception('TODO')
    }

    public func bgBrightMagenta(): Any {
        throw Exception('TODO')
    }

    public func bgBrightRed(): Any {
        throw Exception('TODO')
    }

    public func bgBrightYellow(): Any {
        throw Exception('TODO')
    }

    public func cursor(row: Int64, column: Int64): Any {
        throw Exception('TODO')
    }

    public func cursorToColumn(x: Int64): Any {
        throw Exception('TODO')
    }

    public func cursorUp(y: Int64): Any {
        throw Exception('TODO')
    }

    public func cursorDown(y: Int64): Any {
        throw Exception('TODO')
    }

    public func cursorRight(x: Int64): Any {
        throw Exception('TODO')
    }

    public func cursorLeft(x: Int64): Any {
        throw Exception('TODO')
    }

    public func cursorMove(x: Int64, y: Int64): Any {
        throw Exception('TODO')
    }

    public func scrollUp(rows: Int64): Any {
        throw Exception('TODO')
    }

    public func scrollDown(rows: Int64): Any {
        throw Exception('TODO')
    }

    public func restorCursorPosition(): Any {
        throw Exception('TODO')
    }

    public func saveCursorPosition(): Any {
        throw Exception('TODO')
    }

    public func saveCursorPositionSCO(): Any {
        throw Exception('TODO')
    }

    public func saveCursorPositionDEC(): Any {
        throw Exception('TODO')
    }

    public func restoreCursorPosition(): Any {
        throw Exception('TODO')
    }

    public func restoreCursorPositionSCO(): Any {
        throw Exception('TODO')
    }

    public func restoreCursorPositionDEC(): Any {
        throw Exception('TODO')
    }

    public func reset(): Any {
        throw Exception('TODO')
    }

    public func bold(): Any {
        throw Exception('TODO')
    }

    public func boldOff(): Any {
        throw Exception('TODO')
    }

    public func newline(): Any {
        throw Exception('TODO')
    }

    public func format(pattern: String): Any {
        throw Exception('TODO')
    }

    public func apply(fun: Any): Any {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    private func flushAttributes(): Unit {
        throw Exception('TODO')
    }

    private func _appendEscapeSequence(command: Rune): Any {
        throw Exception('TODO')
    }

    // Methods End
}

class Color {
    // Fields Begin
    var BLACK: Any = throw Exception('TODO')
    var RED: Any = throw Exception('TODO')
    var GREEN: Any = throw Exception('TODO')
    var YELLOW: Any = throw Exception('TODO')
    var BLUE: Any = throw Exception('TODO')
    var MAGENTA: Any = throw Exception('TODO')
    var CYAN: Any = throw Exception('TODO')
    var WHITE: Any = throw Exception('TODO')
    var DEFAULT: Any = throw Exception('TODO')
    let value: Int64 = throw Exception('TODO')
    let name: String = throw Exception('TODO')
    // Fields End

    // Methods Begin
    init(index: Int64, name: String) {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    public func value(): Int64 {
        throw Exception('TODO')
    }

    public func fg(): Int64 {
        throw Exception('TODO')
    }

    public func bg(): Int64 {
        throw Exception('TODO')
    }

    public func fgBright(): Int64 {
        throw Exception('TODO')
    }

    public func bgBright(): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

class Attribute {
    // Fields Begin
    var BLINK_OFF: Any = throw Exception('TODO')
    var NEGATIVE_OFF: Any = throw Exception('TODO')
    var CONCEAL_OFF: Any = throw Exception('TODO')
    var STRIKETHROUGH_OFF: Any = throw Exception('TODO')
    let value: Int64 = throw Exception('TODO')
    let name: String = throw Exception('TODO')
    var RESET: Any = throw Exception('TODO')
    var INTENSITY_BOLD: Any = throw Exception('TODO')
    var INTENSITY_FAINT: Any = throw Exception('TODO')
    var ITALIC: Any = throw Exception('TODO')
    var UNDERLINE: Any = throw Exception('TODO')
    var BLINK_SLOW: Any = throw Exception('TODO')
    var BLINK_FAST: Any = throw Exception('TODO')
    var NEGATIVE_ON: Any = throw Exception('TODO')
    var CONCEAL_ON: Any = throw Exception('TODO')
    var STRIKETHROUGH_ON: Any = throw Exception('TODO')
    var UNDERLINE_DOUBLE: Any = throw Exception('TODO')
    var INTENSITY_BOLD_OFF: Any = throw Exception('TODO')
    var ITALIC_OFF: Any = throw Exception('TODO')
    var UNDERLINE_OFF: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    init(index: Int64, name: String) {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    public func value(): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

class Erase {
    // Fields Begin
    var FORWARD: Any = throw Exception('TODO')
    var BACKWARD: Any = throw Exception('TODO')
    var ALL: Any = throw Exception('TODO')
    let value: Int64 = throw Exception('TODO')
    let name: String = throw Exception('TODO')
    // Fields End

    // Methods Begin
    init(index: Int64, name: String) {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    public func value(): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

interface Consumer {
    // Fields Begin
    // Fields End

    // Methods Begin
    func apply(ansi: Any): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

class NoAnsi <: Ansi {
    // Fields Begin
    // Fields End

    // Methods Begin
    public func fgBright(color: Any): Any {
        throw Exception('TODO')
    }

    public func bgBright(color: Any): Any {
        throw Exception('TODO')
    }

    public func fgRgb(r: Int64, g: Int64, b: Int64): Any {
        throw Exception('TODO')
    }

    public func bgRgb(r: Int64, g: Int64, b: Int64): Any {
        throw Exception('TODO')
    }

    public func a(attribute: Any): Any {
        throw Exception('TODO')
    }

    public func cursor(row: Int64, column: Int64): Any {
        throw Exception('TODO')
    }

    public func cursorToColumn(x: Int64): Any {
        throw Exception('TODO')
    }

    public func cursorUp(y: Int64): Any {
        throw Exception('TODO')
    }

    public func cursorRight(x: Int64): Any {
        throw Exception('TODO')
    }

    public func cursorDown(y: Int64): Any {
        throw Exception('TODO')
    }

    public func cursorLeft(x: Int64): Any {
        throw Exception('TODO')
    }

    public func scrollUp(rows: Int64): Any {
        throw Exception('TODO')
    }

    public func scrollDown(rows: Int64): Any {
        throw Exception('TODO')
    }

    public func saveCursorPosition(): Any {
        throw Exception('TODO')
    }

    public func restorCursorPosition(): Any {
        throw Exception('TODO')
    }

    public func restoreCursorPosition(): Any {
        throw Exception('TODO')
    }

    public func reset(): Any {
        throw Exception('TODO')
    }

    // Methods End
}

