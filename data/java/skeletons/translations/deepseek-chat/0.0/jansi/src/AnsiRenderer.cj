// Package: jansi
package jansi

// Imports Begin
import std.core.*
// Imports End

public open class AnsiRenderer {
    // Fields Begin
    static let BEGIN_TOKEN: String = "@|"
    static let END_TOKEN: String = "|@"
    static let CODE_TEXT_SEPARATOR: String = " "
    static let CODE_LIST_SEPARATOR: String = ","
    static let BEGIN_TOKEN_LEN: Int64 = 2
    static let END_TOKEN_LEN: Int64 = 2
    // Fields End

    // Methods Begin
    public static func render0(input: String): String {
                try {
        return (render1(input, StringBuilder()) as StringBuilder).toString()
        } catch (e: Exception) {
        // Cannot happen because StringBuilder does not throw IOException
        throw IllegalArgumentException(e.message)
        }
    }

    public static func render1(input: String, target: Any): Any {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func render2(text: String): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func renderCodes0(): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func renderCodes1(codes: String): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private static func render3(ansi: Ansi): Ansi {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func test(text: String): Bool {
                return text != "" && text.contains(BEGIN_TOKEN)
    }

    private init() {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    // Methods End
}

public open class Code {
    // Fields Begin
    var BLACK: Any = throw Exception('TODO')  // Already translated, compilation failed
    var RED: Any = throw Exception('TODO')  // Already translated, compilation failed
    var GREEN: Any = throw Exception('TODO')  // Already translated, compilation failed
    var YELLOW: Any = throw Exception('TODO')  // Already translated, compilation failed
    var BLUE: Any = throw Exception('TODO')  // Already translated, compilation failed
    var MAGENTA: Any = throw Exception('TODO')  // Already translated, compilation failed
    var CYAN: Any = throw Exception('TODO')  // Already translated, compilation failed
    var WHITE: Any = throw Exception('TODO')  // Already translated, compilation failed
    var DEFAULT: Any = throw Exception('TODO')  // Already translated, compilation failed
    var FG_BLACK: Any = throw Exception('TODO')  // Already translated, compilation failed
    var FG_RED: Any = throw Exception('TODO')  // Already translated, compilation failed
    var FG_GREEN: Any = throw Exception('TODO')  // Already translated, compilation failed
    var FG_YELLOW: Any = throw Exception('TODO')  // Already translated, compilation failed
    var FG_BLUE: Any = throw Exception('TODO')  // Already translated, compilation failed
    var FG_MAGENTA: Any = Color().MAGENTA  // Already translated, compilation failed
    var FG_CYAN: Any = throw Exception('TODO')  // Already translated, compilation failed
    var FG_WHITE: Any = throw Exception('TODO')  // Already translated, compilation failed
    var FG_DEFAULT: Any = throw Exception('TODO')  // Already translated, compilation failed
    var BG_BLACK: Any = throw Exception('TODO')  // Already translated, compilation failed
    var BG_RED: Any = throw Exception('TODO')  // Already translated, compilation failed
    var BG_GREEN: Any = throw Exception('TODO')  // Already translated, compilation failed
    var BG_YELLOW: Any = throw Exception('TODO')  // Already translated, compilation failed
    var BG_BLUE: Any = throw Exception('TODO')  // Already translated, compilation failed
    var BG_MAGENTA: Any = Color().MAGENTA  // Already translated, compilation failed
    var BG_CYAN: Any = throw Exception('TODO')  // Already translated, compilation failed
    var BG_WHITE: Any = throw Exception('TODO')  // Already translated, compilation failed
    var BG_DEFAULT: Any = throw Exception('TODO')  // Already translated, compilation failed
    var RESET: Any = throw Exception('TODO')  // Already translated, compilation failed
    var INTENSITY_BOLD: Any = throw Exception('TODO')  // Already translated, compilation failed
    var INTENSITY_FAINT: Any = throw Exception('TODO')  // Already translated, compilation failed
    var ITALIC: Any = throw Exception('TODO')  // Already translated, compilation failed
    var UNDERLINE: Any = Attribute().UNDERLINE  // Already translated, compilation failed
    var BLINK_SLOW: Any = throw Exception('TODO')  // Already translated, compilation failed
    var BLINK_FAST: Any = Attribute().BLINK_FAST  // Already translated, compilation failed
    var BLINK_OFF: Any = throw Exception('TODO')  // Already translated, compilation failed
    var NEGATIVE_ON: Any = Attribute().NEGATIVE_ON  // Already translated, compilation failed
    var NEGATIVE_OFF: Any = Attribute().NEGATIVE_OFF  // Already translated, compilation failed
    var CONCEAL_ON: Any = Attribute().CONCEAL_ON  // Already translated, compilation failed
    var CONCEAL_OFF: Any = throw Exception('TODO')  // Already translated, compilation failed
    var UNDERLINE_DOUBLE: Any = Attribute().UNDERLINE_DOUBLE
    var UNDERLINE_OFF: Any = Attribute().UNDERLINE_OFF
    var BOLD: Any = throw Exception('TODO')  // Already translated, compilation failed
    var FAINT: Any = Attribute().INTENSITY_FAINT  // Already translated, compilation failed
    let n: Any = throw Exception("TODO")
    let background: Bool = throw Exception("TODO")
    // Fields End

    // Methods Begin
    init(n: Any, background: Bool) {
        throw Exception('TODO')
    }

    public open func isColor(): Bool {
                return n is Color
    }

    public open func getColor(): Color {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func isAttribute(): Bool {
                return n is Attribute
    }

    public open func getAttribute(): Attribute {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func isBackground(): Bool {
                return this.background
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

