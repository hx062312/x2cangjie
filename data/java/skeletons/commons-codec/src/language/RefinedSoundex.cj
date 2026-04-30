// Package: commons_codec.language
package commons_codec.language

// Imports Begin
// Imports End

open class RefinedSoundex <: StringEncoder {
    // Fields Begin
    static let US_ENGLISH_MAPPING_STRING: String = throw Exception('TODO')
    static let US_ENGLISH_MAPPING: Array<Rune> = throw Exception('TODO')
    let soundexMapping: Array<Rune> = throw Exception('TODO')
    static let US_ENGLISH: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public init(mapping: Array<Rune>) {
        throw Exception('TODO')
    }

    public init(mapping: String) {
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

    func getMappingCode(c: Rune): Rune {
        throw Exception('TODO')
    }

    public func soundex(str: String): String {
        throw Exception('TODO')
    }

    // Methods End
}

