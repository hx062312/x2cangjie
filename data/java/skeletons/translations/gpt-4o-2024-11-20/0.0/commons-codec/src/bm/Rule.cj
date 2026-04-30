// Package: commons_codec.bm
package commons_codec.bm

// Imports Begin
// Imports End

open class Rule {
    // Fields Begin
    static let ALL_STRINGS_RMATCHER: Any = throw Exception('TODO')
    static let ALL: String = throw Exception('TODO')
    static let DOUBLE_QUOTE: String = throw Exception('TODO')
    static let HASH_INCLUDE: String = throw Exception('TODO')
    static let HASH_INCLUDE_LENGTH: Int64 = throw Exception('TODO')
    static let RULES: HashMap<Any, HashMap<Any, HashMap<String, HashMap<String, ArrayList<Any>>>>> = throw Exception('TODO')
    let lContext: Any = throw Exception('TODO')
    let pattern: String = throw Exception('TODO')
    let phoneme: Any = throw Exception('TODO')
    let rContext: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private static func contains(chars: Any, input: Rune): Bool {
        throw Exception('TODO')
    }

    private static func createResourceName(nameType: Any, rt: Any, lang: String): String {
        throw Exception('TODO')
    }

    private static func createScanner(nameType: Any, rt: Any, lang: String): Any {
        throw Exception('TODO')
    }

    private static func createScanner(lang: String): Any {
        throw Exception('TODO')
    }

    private static func endsWith(input: Any, suffix: Any): Bool {
        throw Exception('TODO')
    }

    public static func getInstance(nameType: Any, rt: Any, langs: Any): ArrayList<Any> {
        throw Exception('TODO')
    }

    public static func getInstance(nameType: Any, rt: Any, lang: String): ArrayList<Any> {
        throw Exception('TODO')
    }

    public static func getInstanceMap(nameType: Any, rt: Any, langs: Any): HashMap<String, ArrayList<Any>> {
        throw Exception('TODO')
    }

    public static func getInstanceMap(nameType: Any, rt: Any, lang: String): HashMap<String, ArrayList<Any>> {
        throw Exception('TODO')
    }

    private static func parsePhoneme(ph: String): Any {
        throw Exception('TODO')
    }

    private static func parsePhonemeExpr(ph: String): Any {
        throw Exception('TODO')
    }

    private static func parseRules(scanner: Any, location: String): HashMap<String, ArrayList<Any>> {
        throw Exception('TODO')
    }

    private static func pattern(regex: String): Any {
        throw Exception('TODO')
    }

    private static func startsWith(input: Any, prefix: Any): Bool {
        throw Exception('TODO')
    }

    private static func stripQuotes(str: String): String {
        throw Exception('TODO')
    }

    public init(pattern: String, lContext: String, rContext: String, phoneme: Any) {
        throw Exception('TODO')
    }

    public func getLContext(): Any {
        throw Exception('TODO')
    }

    public func getPattern(): String {
        throw Exception('TODO')
    }

    public func getPhoneme(): Any {
        throw Exception('TODO')
    }

    public func getRContext(): Any {
        throw Exception('TODO')
    }

    public func patternAndContextMatches(input: Any, i: Int64): Bool {
        throw Exception('TODO')
    }

    // Methods End
}

class Phoneme <: PhonemeExpr {
    // Fields Begin
    let phonemeText: Any = throw Exception('TODO')
    let languages: Any = throw Exception('TODO')
    static let COMPARATOR: Comparator<Any> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(phonemeText: Any, languages: Any) {
        throw Exception('TODO')
    }

    public init(phonemeLeft: Any, phonemeRight: Any) {
        throw Exception('TODO')
    }

    public init(phonemeLeft: Any, phonemeRight: Any, languages: Any) {
        throw Exception('TODO')
    }

    public func append(str: Any): Any {
        throw Exception('TODO')
    }

    public func getLanguages(): Any {
        throw Exception('TODO')
    }

    public func getPhonemes(): Iterable<Any> {
        throw Exception('TODO')
    }

    public func getPhonemeText(): Any {
        throw Exception('TODO')
    }

    public func join(right: Any): Any {
        throw Exception('TODO')
    }

    public func mergeWithLanguage(lang: Any): Any {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

open interface PhonemeExpr {
    // Fields Begin
    // Fields End

    // Methods Begin
    func getPhonemes(): Iterable<Any> {
        throw Exception('TODO')
    }

    // Methods End
}

class PhonemeList <: PhonemeExpr {
    // Fields Begin
    let phonemes: ArrayList<Any> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(phonemes: ArrayList<Any>) {
        throw Exception('TODO')
    }

    public func getPhonemes(): ArrayList<Any> {
        throw Exception('TODO')
    }

    // Methods End
}

open interface RPattern {
    // Fields Begin
    // Fields End

    // Methods Begin
    func isMatch(input: Any): Bool {
        throw Exception('TODO')
    }

    // Methods End
}

