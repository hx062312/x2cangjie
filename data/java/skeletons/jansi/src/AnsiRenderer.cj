// Package: jansi
package jansi

// Imports Begin
// Imports End

class AnsiRenderer {
    // Fields Begin
    static let BEGIN_TOKEN: String = throw Exception('TODO')
    static let END_TOKEN: String = throw Exception('TODO')
    static let CODE_TEXT_SEPARATOR: String = throw Exception('TODO')
    static let CODE_LIST_SEPARATOR: String = throw Exception('TODO')
    static let BEGIN_TOKEN_LEN: Int64 = throw Exception('TODO')
    static let END_TOKEN_LEN: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func test(text: String): Bool {
        throw Exception('TODO')
    }

    private init() {
        throw Exception('TODO')
    }

    // Methods End
}

class Code {
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
    var FG_BLACK: Any = throw Exception('TODO')
    var FG_RED: Any = throw Exception('TODO')
    var FG_GREEN: Any = throw Exception('TODO')
    var FG_YELLOW: Any = throw Exception('TODO')
    var FG_BLUE: Any = throw Exception('TODO')
    var FG_MAGENTA: Any = throw Exception('TODO')
    var FG_CYAN: Any = throw Exception('TODO')
    var FG_WHITE: Any = throw Exception('TODO')
    var FG_DEFAULT: Any = throw Exception('TODO')
    var BG_BLACK: Any = throw Exception('TODO')
    var BG_RED: Any = throw Exception('TODO')
    var BG_GREEN: Any = throw Exception('TODO')
    var BG_YELLOW: Any = throw Exception('TODO')
    var BG_BLUE: Any = throw Exception('TODO')
    var BG_MAGENTA: Any = throw Exception('TODO')
    var BG_CYAN: Any = throw Exception('TODO')
    var BG_WHITE: Any = throw Exception('TODO')
    var BG_DEFAULT: Any = throw Exception('TODO')
    var RESET: Any = throw Exception('TODO')
    var INTENSITY_BOLD: Any = throw Exception('TODO')
    var INTENSITY_FAINT: Any = throw Exception('TODO')
    var ITALIC: Any = throw Exception('TODO')
    var UNDERLINE: Any = throw Exception('TODO')
    var BLINK_SLOW: Any = throw Exception('TODO')
    var BLINK_FAST: Any = throw Exception('TODO')
    var BLINK_OFF: Any = throw Exception('TODO')
    var NEGATIVE_ON: Any = throw Exception('TODO')
    var NEGATIVE_OFF: Any = throw Exception('TODO')
    var CONCEAL_ON: Any = throw Exception('TODO')
    var CONCEAL_OFF: Any = throw Exception('TODO')
    var UNDERLINE_DOUBLE: Any = throw Exception('TODO')
    var UNDERLINE_OFF: Any = throw Exception('TODO')
    var BOLD: Any = throw Exception('TODO')
    var FAINT: Any = throw Exception('TODO')
    let n: Enum<Any> = throw Exception('TODO')
    let background: Bool = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public func isColor(): Bool {
        throw Exception('TODO')
    }

    public func getColor(): Any {
        throw Exception('TODO')
    }

    public func isAttribute(): Bool {
        throw Exception('TODO')
    }

    public func getAttribute(): Any {
        throw Exception('TODO')
    }

    public func isBackground(): Bool {
        throw Exception('TODO')
    }

    // Methods End
}

