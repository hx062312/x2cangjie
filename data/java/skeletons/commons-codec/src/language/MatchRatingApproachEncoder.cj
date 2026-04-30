// Package: commons_codec.language
package commons_codec.language

// Imports Begin
// Imports End

open class MatchRatingApproachEncoder <: StringEncoder {
    // Fields Begin
    static let SPACE: String = throw Exception('TODO')
    static let EMPTY: String = throw Exception('TODO')
    static let PLAIN_ASCII: String = throw Exception('TODO')
    static let UNICODE: String = throw Exception('TODO')
    static let DOUBLE_CONSONANT: Array<String> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    func cleanName(name: String): String {
        throw Exception('TODO')
    }

    public func encode(pObject: Any): Any {
        throw Exception('TODO')
    }

    public func encode(name: String): String {
        throw Exception('TODO')
    }

    func getFirst3Last3(name: String): String {
        throw Exception('TODO')
    }

    func getMinRating(sumLength: Int64): Int64 {
        throw Exception('TODO')
    }

    public func isEncodeEquals(name1: String, name2: String): Bool {
        throw Exception('TODO')
    }

    func isVowel(letter: String): Bool {
        throw Exception('TODO')
    }

    func leftToRightThenRightToLeftProcessing(name1: String, name2: String): Int64 {
        throw Exception('TODO')
    }

    func removeAccents(accentedWord: String): String {
        throw Exception('TODO')
    }

    func removeDoubleConsonants(name: String): String {
        throw Exception('TODO')
    }

    func removeVowels(name: String): String {
        throw Exception('TODO')
    }

    // Methods End
}

