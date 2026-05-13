// Package: jansi
package jansi

// Imports Begin
import std.collection.ArrayList
// Imports End

public open class Ansi {
    // Fields Begin
    static let DISABLE: String = throw Exception('TODO')
    static var detector: Callable<Bool> = throw Exception('TODO')
    static let holder: InheritableThreadLocal<Bool> = throw Exception('TODO')
    static let FIRST_ESC_CHAR: Rune = throw Exception('TODO')
    static let SECOND_ESC_CHAR: Rune = throw Exception('TODO')
    let builder: StringBuilder = throw Exception('TODO')
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

    public static func ansi(): Ansi {
        throw Exception('TODO')
    }

    public static func ansi(builder: StringBuilder): Ansi {
        throw Exception('TODO')
    }

    public static func ansi(size: Int64): Ansi {
        throw Exception('TODO')
    }

    public init() {
        throw Exception('TODO')
    }

    public init(parent: Ansi) {
        throw Exception('TODO')
    }

    public init(size: Int64) {
        throw Exception('TODO')
    }

    public init(builder: StringBuilder) {
        throw Exception('TODO')
    }

    public open func fg(color: Color): Ansi {
        throw Exception('TODO')
    }

    public open func fg(color: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func fgRgb(color: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func fgRgb(r: Int64, g: Int64, b: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func fgBlack(): Ansi {
        throw Exception('TODO')
    }

    public open func fgBlue(): Ansi {
        throw Exception('TODO')
    }

    public open func fgCyan(): Ansi {
        throw Exception('TODO')
    }

    public open func fgDefault(): Ansi {
        throw Exception('TODO')
    }

    public open func fgGreen(): Ansi {
        throw Exception('TODO')
    }

    public open func fgMagenta(): Ansi {
        throw Exception('TODO')
    }

    public open func fgRed(): Ansi {
        throw Exception('TODO')
    }

    public open func fgYellow(): Ansi {
        throw Exception('TODO')
    }

    public open func bg(color: Color): Ansi {
        throw Exception('TODO')
    }

    public open func bg(color: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func bgRgb(color: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func bgRgb(r: Int64, g: Int64, b: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func bgCyan(): Ansi {
        throw Exception('TODO')
    }

    public open func bgDefault(): Ansi {
        throw Exception('TODO')
    }

    public open func bgGreen(): Ansi {
        throw Exception('TODO')
    }

    public open func bgMagenta(): Ansi {
        throw Exception('TODO')
    }

    public open func bgRed(): Ansi {
        throw Exception('TODO')
    }

    public open func bgYellow(): Ansi {
        throw Exception('TODO')
    }

    public open func fgBright(color: Color): Ansi {
        throw Exception('TODO')
    }

    public open func fgBrightBlack(): Ansi {
        throw Exception('TODO')
    }

    public open func fgBrightBlue(): Ansi {
        throw Exception('TODO')
    }

    public open func fgBrightCyan(): Ansi {
        throw Exception('TODO')
    }

    public open func fgBrightDefault(): Ansi {
        throw Exception('TODO')
    }

    public open func fgBrightGreen(): Ansi {
        throw Exception('TODO')
    }

    public open func fgBrightMagenta(): Ansi {
        throw Exception('TODO')
    }

    public open func fgBrightRed(): Ansi {
        throw Exception('TODO')
    }

    public open func fgBrightYellow(): Ansi {
        throw Exception('TODO')
    }

    public open func bgBright(color: Color): Ansi {
        throw Exception('TODO')
    }

    public open func bgBrightCyan(): Ansi {
        throw Exception('TODO')
    }

    public open func bgBrightDefault(): Ansi {
        throw Exception('TODO')
    }

    public open func bgBrightGreen(): Ansi {
        throw Exception('TODO')
    }

    public open func bgBrightMagenta(): Ansi {
        throw Exception('TODO')
    }

    public open func bgBrightRed(): Ansi {
        throw Exception('TODO')
    }

    public open func bgBrightYellow(): Ansi {
        throw Exception('TODO')
    }

    public open func a(attribute: Attribute): Ansi {
        throw Exception('TODO')
    }

    public open func cursor(row: Int64, column: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func cursorToColumn(x: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func cursorUp(y: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func cursorDown(y: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func cursorRight(x: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func cursorLeft(x: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func cursorMove(x: Int64, y: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func cursorDownLine(): Ansi {
        throw Exception('TODO')
    }

    public open func cursorDownLine(n: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func cursorUpLine(): Ansi {
        throw Exception('TODO')
    }

    public open func cursorUpLine(n: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func eraseScreen(): Ansi {
        throw Exception('TODO')
    }

    public open func eraseScreen(kind: Erase): Ansi {
        throw Exception('TODO')
    }

    public open func eraseLine(): Ansi {
        throw Exception('TODO')
    }

    public open func eraseLine(kind: Erase): Ansi {
        throw Exception('TODO')
    }

    public open func scrollUp(rows: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func scrollDown(rows: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func restorCursorPosition(): Ansi {
        throw Exception('TODO')
    }

    public open func saveCursorPosition(): Ansi {
        throw Exception('TODO')
    }

    public open func saveCursorPositionSCO(): Ansi {
        throw Exception('TODO')
    }

    public open func saveCursorPositionDEC(): Ansi {
        throw Exception('TODO')
    }

    public open func restoreCursorPosition(): Ansi {
        throw Exception('TODO')
    }

    public open func restoreCursorPositionSCO(): Ansi {
        throw Exception('TODO')
    }

    public open func restoreCursorPositionDEC(): Ansi {
        throw Exception('TODO')
    }

    public open func reset(): Ansi {
        throw Exception('TODO')
    }

    public open func bold(): Ansi {
        throw Exception('TODO')
    }

    public open func boldOff(): Ansi {
        throw Exception('TODO')
    }

    public open func a(value: String): Ansi {
        throw Exception('TODO')
    }

    public open func a(value: Bool): Ansi {
        throw Exception('TODO')
    }

    public open func a(value: Rune): Ansi {
        throw Exception('TODO')
    }

    public open func a(value: Array<UInt16>, offset: Int64, len: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func a(value: Array<UInt16>): Ansi {
        throw Exception('TODO')
    }

    public open func a(value: String, start: Int64, end: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func a_1(value: String): Ansi {
        throw Exception('TODO')
    }

    public open func a(value: Float64): Ansi {
        throw Exception('TODO')
    }

    public open func a(value: Float32): Ansi {
        throw Exception('TODO')
    }

    public open func a(value: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func a_1(value: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func a(value: Any): Ansi {
        throw Exception('TODO')
    }

    public open func a(value: StringBuilder): Ansi {
        throw Exception('TODO')
    }

    public open func newline(): Ansi {
        throw Exception('TODO')
    }

    public open func format(pattern: String): Ansi {
        throw Exception('TODO')
    }

    public open func apply(fun: Ansi_Consumer): Ansi {
        throw Exception('TODO')
    }

    public open func render(text: String): Ansi {
        throw Exception('TODO')
    }

    public open func render_1(text: String): Ansi {
        throw Exception('TODO')
    }

    public open func toString(): String {
        throw Exception('TODO')
    }

    private func appendEscapeSequence(command: Rune): Ansi {
        throw Exception('TODO')
    }

    private func appendEscapeSequence(command: Rune, option: Int64): Ansi {
        throw Exception('TODO')
    }

    private func appendEscapeSequence_1(command: Rune): Ansi {
        throw Exception('TODO')
    }

    private func flushAttributes(): Unit {
        throw Exception('TODO')
    }

    private func _appendEscapeSequence(command: Rune): Ansi {
        throw Exception('TODO')
    }

    public open func append(csq: String): Ansi {
        throw Exception('TODO')
    }

    public open func append(csq: String, start: Int64, end: Int64): Ansi {
        throw Exception('TODO')
    }

    public open func append(c: Rune): Ansi {
        throw Exception('TODO')
    }

    // Methods End
}

public open class Color {
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

    public open func toString(): String {
        throw Exception('TODO')
    }

    public open func value_method(): Int64 {
        throw Exception('TODO')
    }

    public open func fg(): Int64 {
        throw Exception('TODO')
    }

    public open func bg(): Int64 {
        throw Exception('TODO')
    }

    public open func fgBright(): Int64 {
        throw Exception('TODO')
    }

    public open func bgBright(): Int64 {
        throw Exception('TODO')
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

public open class Attribute {
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

    public open func toString(): String {
        throw Exception('TODO')
    }

    public open func value_method(): Int64 {
        throw Exception('TODO')
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

public open class Erase {
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

    public open func toString(): String {
        throw Exception('TODO')
    }

    public open func value_method(): Int64 {
        throw Exception('TODO')
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

public interface Ansi_Consumer {
    // Methods Begin
    func apply(ansi: Ansi): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

private open class Ansi_NoAnsi <: Ansi {
    // Fields Begin
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public init(size: Int64) {
        throw Exception('TODO')
    }

    public init(builder: StringBuilder) {
        throw Exception('TODO')
    }

    public override func fg(color: Color): Ansi {
        throw Exception('TODO')
    }

    public override func bg(color: Color): Ansi {
        throw Exception('TODO')
    }

    public override func fgBright(color: Color): Ansi {
        throw Exception('TODO')
    }

    public override func bgBright(color: Color): Ansi {
        throw Exception('TODO')
    }

    public override func fg(color: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func fgRgb(r: Int64, g: Int64, b: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func bg(color: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func bgRgb(r: Int64, g: Int64, b: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func a(attribute: Attribute): Ansi {
        throw Exception('TODO')
    }

    public override func cursor(row: Int64, column: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func cursorToColumn(x: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func cursorUp(y: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func cursorRight(x: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func cursorDown(y: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func cursorLeft(x: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func cursorDownLine(): Ansi {
        throw Exception('TODO')
    }

    public override func cursorDownLine(n: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func cursorUpLine(): Ansi {
        throw Exception('TODO')
    }

    public override func cursorUpLine(n: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func eraseScreen(): Ansi {
        throw Exception('TODO')
    }

    public override func eraseScreen(kind: Erase): Ansi {
        throw Exception('TODO')
    }

    public override func eraseLine(): Ansi {
        throw Exception('TODO')
    }

    public override func eraseLine(kind: Erase): Ansi {
        throw Exception('TODO')
    }

    public override func scrollUp(rows: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func scrollDown(rows: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func saveCursorPosition(): Ansi {
        throw Exception('TODO')
    }

    public override func restorCursorPosition(): Ansi {
        throw Exception('TODO')
    }

    public override func restoreCursorPosition(): Ansi {
        throw Exception('TODO')
    }

    public override func reset(): Ansi {
        throw Exception('TODO')
    }

    // Methods End
}

