// Package: jansi
package jansi

// Imports Begin
import std.collection.ArrayList
import std.core.*
import std.core.String
// Imports End

public open class Ansi {
    // Fields Begin
    static let DISABLE: String = "Ansi.disable"  // Already translated, compilation failed
    static var detector: Any = throw Exception('TODO')  // Already translated, compilation failed
    static let holder: ThreadLocal<Bool> = throw Exception('TODO')  // Already translated, compilation failed
    static let FIRST_ESC_CHAR: Rune = Rune(27)  // Already translated, compilation failed
    static let SECOND_ESC_CHAR: Rune = '['
    let builder: Any = StringBuilder()
    let attributeOptions: ArrayList<Int64> = ArrayList<Int64>(5)
    // Fields End

    // Methods Begin
    public static func setDetector(detector: Any): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func isDetected(): Bool {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func setEnabled(flag: Bool): Unit {
                holder.set(flag)
    }

    public static func isEnabled(): Bool {
                return holder.get().getOrThrow()
    }

    public static func ansi0(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func ansi1(builder: Any): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func ansi2(size: Int64): Ansi {
                if (isEnabled()) {
        return Ansi.Ansi2(size)
        } else {
        return Ansi_NoAnsi(size)
        }
    }

    public static func Ansi0(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func Ansi1(parent: Ansi): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func Ansi2(size: Int64): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(constructorId: Int64, builder: Any, parent: Ansi) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fg0(color: Color): Ansi {
                attributeOptions.add(color.fg())
        return this
    }

    public open func fg1(color: Int64): Ansi {
                return this
    }

    public open func fgRgb0(color: Int64): Ansi {
                return fgRgb1(color >> 16, color >> 8, color)
    }

    public open func fgRgb1(r: Int64, g: Int64, b: Int64): Ansi {
                return this
    }

    public open func fgBlack(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgBlue(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgCyan(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgDefault(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgGreen(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgMagenta(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgRed(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgYellow(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func bg0(color: Color): Ansi {
                attributeOptions.add(color.bg())
        return this
    }

    public open func bg1(color: Int64): Ansi {
                return this
    }

    public open func bgRgb0(color: Int64): Ansi {
                return bgRgb1(color >> 16, color >> 8, color)
    }

    public open func bgRgb1(r: Int64, g: Int64, b: Int64): Ansi {
                return this
    }

    public open func bgCyan(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func bgDefault(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func bgGreen(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func bgMagenta(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func bgRed(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func bgYellow(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgBright(color: Color): Ansi {
                attributeOptions.add(color.fgBright())
        return this
    }

    public open func fgBrightBlack(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgBrightBlue(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgBrightCyan(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgBrightDefault(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgBrightGreen(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgBrightMagenta(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgBrightRed(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func fgBrightYellow(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func bgBright(color: Color): Ansi {
                attributeOptions.add(color.bgBright())
        return this
    }

    public open func bgBrightCyan(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func bgBrightDefault(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func bgBrightGreen(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func bgBrightMagenta(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func bgBrightRed(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func bgBrightYellow(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func a0(attribute: Attribute): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func cursor(row: Int64, column: Int64): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func cursorToColumn(x: Int64): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func cursorUp(y: Int64): Ansi {
                if (y > 0) {
        return appendEscapeSequence1(r'A', y)
        } else if (y < 0) {
        return cursorDown(-y)
        } else {
        return this
        }
    }

    public open func cursorDown(y: Int64): Ansi {
                if (y > 0) {
        return appendEscapeSequence1(r'B', y)
        } else if (y < 0) {
        return cursorUp(-y)
        } else {
        return this
        }
    }

    public open func cursorRight(x: Int64): Ansi {
                if (x > 0) {
        return appendEscapeSequence1(r'C', x)
        } else if (x < 0) {
        return cursorLeft(-x)
        } else {
        return this
        }
    }

    public open func cursorLeft(x: Int64): Ansi {
                if (x > 0) {
        return appendEscapeSequence1(r'D', x)
        } else if (x < 0) {
        return cursorRight(-x)
        } else {
        return this
        }
    }

    public open func cursorMove(x: Int64, y: Int64): Ansi {
                return cursorRight(x).cursorDown(y)
    }

    public open func cursorDownLine0(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func cursorDownLine1(n: Int64): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func cursorUpLine0(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func cursorUpLine1(n: Int64): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func eraseScreen0(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func eraseScreen1(kind: Erase): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func eraseLine0(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func eraseLine1(kind: Erase): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func scrollUp(rows: Int64): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func scrollDown(rows: Int64): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func restorCursorPosition(): Ansi {
                return restoreCursorPosition()
    }

    public open func saveCursorPosition(): Ansi {
                saveCursorPositionSCO()
        return saveCursorPositionDEC()
    }

    public open func saveCursorPositionSCO(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func saveCursorPositionDEC(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func restoreCursorPosition(): Ansi {
                restoreCursorPositionSCO()
        return restoreCursorPositionDEC()
    }

    public open func restoreCursorPositionSCO(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func restoreCursorPositionDEC(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func reset(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func bold(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func boldOff(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func a1(value: String): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func a2(value: Bool): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func a3(value: Rune): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func a4(value: Array<Rune>, offset: Int64, len: Int64): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func a5(value: Array<Rune>): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func a6(value: String, start: Int64, end: Int64): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func a7(value: String): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func a8(value: Float64): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func a9(value: Float32): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func a10(value: Int64): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func a11(value: Int64): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func a12(value: Any): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func a13(value: StringBuilder): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func newline(): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func format(pattern: String): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func apply(fun: Ansi_Consumer): Ansi {
                fun.apply(this)
        return this
    }

    public open func render0(text: String): Ansi {
                a1(AnsiRenderer.render0(text))
        return this
    }

    public open func render1(text: String): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func toString(): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func appendEscapeSequence0(command: Rune): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func appendEscapeSequence1(command: Rune, option: Int64): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func appendEscapeSequence2(command: Rune): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func flushAttributes(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func _appendEscapeSequence(command: Rune): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func append(csq: String): Ansi {
                return append0(csq)
    }

    public open func append0(csq: String): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func append(csq: String, start: Int64, end: Int64): Ansi {
                return append1(csq, start, end)
    }

    public open func append1(csq: String, start: Int64, end: Int64): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func append(c: Rune): Ansi {
                return append2(c)
    }

    public open func append2(c: Rune): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

public open class Color {
    // Fields Begin
    var BLACK: Any = throw Exception('TODO')  // Already translated, compilation failed
    var RED: Any = throw Exception("TODO")
    var GREEN: Any = throw Exception('TODO')  // Already translated, compilation failed
    var YELLOW: Any = throw Exception('TODO')  // Already translated, compilation failed
    var BLUE: Any = throw Exception('TODO')  // Already translated, compilation failed
    var MAGENTA: Any = 5
    var CYAN: Any = throw Exception('TODO')  // Already translated, compilation failed
    var WHITE: Any = throw Exception('TODO')  // Already translated, compilation failed
    var DEFAULT: Any = 9
    let value: Int64 = 0
    let name: String = ""  // Already translated, compilation failed
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
                return value + 30
    }

    public open func bg(): Int64 {
                return value + 40
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
    var ITALIC_OFF: Any = throw Exception('TODO')  // Already translated, compilation failed
    var UNDERLINE_OFF: Any = 24
    var BLINK_OFF: Any = 25
    var NEGATIVE_OFF: Any = 27
    var CONCEAL_OFF: Any = 28
    var STRIKETHROUGH_OFF: Any = throw Exception('TODO')  // Already translated, compilation failed
    let value: Int64 = 0
    let name: String = throw Exception('TODO')
    var RESET: Any = 0
    var INTENSITY_BOLD: Any = 1
    var INTENSITY_FAINT: Any = 2
    var ITALIC: Any = throw Exception('TODO')  // Already translated, compilation failed
    var UNDERLINE: Any = 4
    var BLINK_SLOW: Any = 5
    var BLINK_FAST: Any = 6
    var NEGATIVE_ON: Any = 7
    var CONCEAL_ON: Any = 8
    var STRIKETHROUGH_ON: Any = 9
    var UNDERLINE_DOUBLE: Any = 21
    var INTENSITY_BOLD_OFF: Any = 22
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
    var FORWARD: Any = 0
    var BACKWARD: Any = 1
    var ALL: Any = throw Exception('TODO')  // Already translated, compilation failed
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
    public init(args: Any) {
        super()
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private static func determineStringBuilder(args: Any): Any {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public override func fg0(color: Color): Ansi {
        throw Exception('TODO')
    }

    public override func bg0(color: Color): Ansi {
        throw Exception('TODO')
    }

    public override func fgBright(color: Color): Ansi {
        throw Exception('TODO')
    }

    public override func bgBright(color: Color): Ansi {
        throw Exception('TODO')
    }

    public override func fg1(color: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func fgRgb1(r: Int64, g: Int64, b: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func bg1(color: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func bgRgb1(r: Int64, g: Int64, b: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func a0(attribute: Attribute): Ansi {
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

    public override func cursorDownLine0(): Ansi {
        throw Exception('TODO')
    }

    public override func cursorDownLine1(n: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func cursorUpLine0(): Ansi {
        throw Exception('TODO')
    }

    public override func cursorUpLine1(n: Int64): Ansi {
        throw Exception('TODO')
    }

    public override func eraseScreen0(): Ansi {
        throw Exception('TODO')
    }

    public override func eraseScreen1(kind: Erase): Ansi {
        throw Exception('TODO')
    }

    public override func eraseLine0(): Ansi {
        throw Exception('TODO')
    }

    public override func eraseLine1(kind: Erase): Ansi {
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

    protected init() {
        throw Exception('TODO')
    }
}

