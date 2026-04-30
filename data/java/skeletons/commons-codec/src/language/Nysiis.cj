// Package: commons_codec.language
package commons_codec.language

// Imports Begin
// Imports End

open class Nysiis <: StringEncoder {
    // Fields Begin
    let strict: Bool = throw Exception('TODO')
    static let CHARS_A: Array<Rune> = throw Exception('TODO')
    static let CHARS_AF: Array<Rune> = throw Exception('TODO')
    static let CHARS_C: Array<Rune> = throw Exception('TODO')
    static let CHARS_FF: Array<Rune> = throw Exception('TODO')
    static let CHARS_G: Array<Rune> = throw Exception('TODO')
    static let CHARS_N: Array<Rune> = throw Exception('TODO')
    static let CHARS_NN: Array<Rune> = throw Exception('TODO')
    static let CHARS_S: Array<Rune> = throw Exception('TODO')
    static let CHARS_SSS: Array<Rune> = throw Exception('TODO')
    static let PAT_MAC: Regex = throw Exception('TODO')
    static let PAT_KN: Regex = throw Exception('TODO')
    static let PAT_K: Regex = throw Exception('TODO')
    static let PAT_PH_PF: Regex = throw Exception('TODO')
    static let PAT_SCH: Regex = throw Exception('TODO')
    static let PAT_EE_IE: Regex = throw Exception('TODO')
    static let PAT_DT_ETC: Regex = throw Exception('TODO')
    static let SPACE: Rune = throw Exception('TODO')
    static let TRUE_LENGTH: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private static func isVowel(c: Rune): Bool {
        throw Exception('TODO')
    }

    private static func transcodeRemaining(prev: Rune, curr: Rune, next: Rune, aNext: Rune): Array<Rune> {
        throw Exception('TODO')
    }

    public init() {
        throw Exception('TODO')
    }

    public init(strict: Bool) {
        throw Exception('TODO')
    }

    public open func encode(obj: Any): Any {
        throw Exception('TODO')
    }

    public open func encode(str: String): String {
        throw Exception('TODO')
    }

    public func isStrict(): Bool {
        throw Exception('TODO')
    }

    public func nysiis(str: String): String {
        throw Exception('TODO')
    }

    // Methods End
}

