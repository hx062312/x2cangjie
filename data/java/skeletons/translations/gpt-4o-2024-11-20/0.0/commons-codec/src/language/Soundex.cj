// Package: commons_codec.language
package commons_codec.language

// Imports Begin
// Imports End

open class Soundex <: StringEncoder {
    // Fields Begin
    static let US_ENGLISH_GENEALOGY: Any = throw Exception('TODO')
    var maxLength: Int64 = throw Exception('TODO')
    let soundexMapping: Array<Rune> = throw Exception('TODO')
    let specialCaseHW: Bool = throw Exception('TODO')
    static let SILENT_MARKER: Rune = throw Exception('TODO')
    static let US_ENGLISH_MAPPING_STRING: String = throw Exception('TODO')
    static let US_ENGLISH_MAPPING: Array<Rune> = throw Exception('TODO')
    static let US_ENGLISH: Any = throw Exception('TODO')
    static let US_ENGLISH_SIMPLIFIED: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public init(mapping: Array<Rune>) {
        throw Exception('TODO')
    }

    private func hasMarker(mapping: Array<Rune>): Bool {
        throw Exception('TODO')
    }

    public init(mapping: String) {
        throw Exception('TODO')
    }

    public init(mapping: String, specialCaseHW: Bool) {
        throw Exception('TODO')
    }

    public func difference(s1: String, s2: String): Int64 {
        throw Exception('TODO')
    }

    public open func encode(obj: Any): Any {
        throw Exception('TODO')
    }

    public open func encode(str: String): String {
        throw Exception('TODO')
    }

    public func getMaxLength(): Int64 {
        throw Exception('TODO')
    }

    private func map(ch: Rune): Rune {
        throw Exception('TODO')
    }

    public func setMaxLength(maxLength: Int64): Unit {
        throw Exception('TODO')
    }

    public func soundex(str: String): String {
        throw Exception('TODO')
    }

    // Methods End
}

