// Package: commons_codec.bm
package commons_codec.bm

// Imports Begin
// Imports End

open class PhoneticEngine {
    // Fields Begin
    static let NAME_PREFIXES: HashMap<Any, Set<String>> = throw Exception('TODO')
    static let DEFAULT_MAX_PHONEMES: Int64 = throw Exception('TODO')
    let lang: Any = throw Exception('TODO')
    let nameType: Any = throw Exception('TODO')
    let ruleType: Any = throw Exception('TODO')
    let concat: Bool = throw Exception('TODO')
    let maxPhonemes: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private static func join(strings: Iterable<String>, sep: String): String {
        throw Exception('TODO')
    }

    public init(nameType: Any, ruleType: Any, concat: Bool) {
        throw Exception('TODO')
    }

    public init(nameType: Any, ruleType: Any, concat: Bool, maxPhonemes: Int64) {
        throw Exception('TODO')
    }

    private func applyFinalRules(phonemeBuilder: Any, finalRules: HashMap<String, ArrayList<Any>>): Any {
        throw Exception('TODO')
    }

    public open func encode(input: String): String {
        throw Exception('TODO')
    }

    public open func encode(input: String, languageSet: Any): String {
        throw Exception('TODO')
    }

    public func getLang(): Any {
        throw Exception('TODO')
    }

    public func getNameType(): Any {
        throw Exception('TODO')
    }

    public func getRuleType(): Any {
        throw Exception('TODO')
    }

    public func isConcat(): Bool {
        throw Exception('TODO')
    }

    public func getMaxPhonemes(): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

class PhonemeBuilder {
    // Fields Begin
    let phonemes: Set<Any> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func empty(languages: Any): Any {
        throw Exception('TODO')
    }

    private init(phoneme: Any) {
        throw Exception('TODO')
    }

    private init(phonemes: Set<Any>) {
        throw Exception('TODO')
    }

    public func append(str: Any): Unit {
        throw Exception('TODO')
    }

    public func apply(phonemeExpr: Any, maxPhonemes: Int64): Unit {
        throw Exception('TODO')
    }

    public func getPhonemes(): Set<Any> {
        throw Exception('TODO')
    }

    public func makeString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

class RulesApplication {
    // Fields Begin
    let finalRules: HashMap<String, ArrayList<Any>> = throw Exception('TODO')
    let input: Any = throw Exception('TODO')
    let phonemeBuilder: Any = throw Exception('TODO')
    var i: Int64 = throw Exception('TODO')
    let maxPhonemes: Int64 = throw Exception('TODO')
    var found: Bool = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(finalRules: HashMap<String, ArrayList<Any>>, input: Any, phonemeBuilder: Any, i: Int64, maxPhonemes: Int64) {
        throw Exception('TODO')
    }

    public func getI(): Int64 {
        throw Exception('TODO')
    }

    public func getPhonemeBuilder(): Any {
        throw Exception('TODO')
    }

    public func invoke(): Any {
        throw Exception('TODO')
    }

    public func isFound(): Bool {
        throw Exception('TODO')
    }

    // Methods End
}

