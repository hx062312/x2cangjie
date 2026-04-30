// Package: commons_codec.language
package commons_codec.language

// Imports Begin
// Imports End

open class Metaphone <: StringEncoder {
    // Fields Begin
    static let VOWELS: String = throw Exception('TODO')
    static let FRONTV: String = throw Exception('TODO')
    static let VARSON: String = throw Exception('TODO')
    var maxCodeLen: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public func metaphone(txt: String): String {
        throw Exception('TODO')
    }

    private func isVowel(string: Any, index: Int64): Bool {
        throw Exception('TODO')
    }

    private func isPreviousChar(string: Any, index: Int64, c: Rune): Bool {
        throw Exception('TODO')
    }

    private func isNextChar(string: Any, index: Int64, c: Rune): Bool {
        throw Exception('TODO')
    }

    private func regionMatch(string: Any, index: Int64, test: String): Bool {
        throw Exception('TODO')
    }

    private func isLastChar(wdsz: Int64, n: Int64): Bool {
        throw Exception('TODO')
    }

    public open func encode(obj: Any): Any {
        throw Exception('TODO')
    }

    public open func encode(str: String): String {
        throw Exception('TODO')
    }

    public func isMetaphoneEqual(str1: String, str2: String): Bool {
        throw Exception('TODO')
    }

    public func getMaxCodeLen(): Int64 {
        throw Exception('TODO')
    }

    public func setMaxCodeLen(maxCodeLen: Int64): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

