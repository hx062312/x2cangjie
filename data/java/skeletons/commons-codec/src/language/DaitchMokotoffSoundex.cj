// Package: commons_codec.language
package commons_codec.language

// Imports Begin
// Imports End

open class DaitchMokotoffSoundex <: StringEncoder {
    // Fields Begin
    static let COMMENT: String = throw Exception('TODO')
    static let DOUBLE_QUOTE: String = throw Exception('TODO')
    static let MULTILINE_COMMENT_END: String = throw Exception('TODO')
    static let MULTILINE_COMMENT_START: String = throw Exception('TODO')
    static let RESOURCE_FILE: String = throw Exception('TODO')
    static let MAX_LENGTH: Int64 = throw Exception('TODO')
    static let RULES: HashMap<Rune, ArrayList<Any>> = throw Exception('TODO')
    static let FOLDINGS: HashMap<Rune, Rune> = throw Exception('TODO')
    let folding: Bool = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private static func parseRules(scanner: Any, location: String, ruleMapping: HashMap<Rune, ArrayList<Any>>, asciiFoldings: HashMap<Rune, Rune>): Unit {
        throw Exception('TODO')
    }

    private static func stripQuotes(str: String): String {
        throw Exception('TODO')
    }

    public init() {
        throw Exception('TODO')
    }

    public init(folding: Bool) {
        throw Exception('TODO')
    }

    private func cleanup(input: String): String {
        throw Exception('TODO')
    }

    public open func encode(obj: Any): Any {
        throw Exception('TODO')
    }

    public open func encode(source: String): String {
        throw Exception('TODO')
    }

    public open func soundex(source: String): String {
        throw Exception('TODO')
    }

    private open func soundex(source: String, branching: Bool): Array<String> {
        throw Exception('TODO')
    }

    // Methods End
}

class Branch {
    // Fields Begin
    let builder: Any = throw Exception('TODO')
    var cachedString: String = throw Exception('TODO')
    var lastReplacement: String = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private init() {
        throw Exception('TODO')
    }

    public func createBranch(): Any {
        throw Exception('TODO')
    }

    public func equals(other: Any): Bool {
        throw Exception('TODO')
    }

    public func finish(): Unit {
        throw Exception('TODO')
    }

    public func hashCode(): Int64 {
        throw Exception('TODO')
    }

    public func processNextReplacement(replacement: String, forceAppend: Bool): Unit {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

class Rule {
    // Fields Begin
    let pattern: String = throw Exception('TODO')
    let replacementAtStart: Array<String> = throw Exception('TODO')
    let replacementBeforeVowel: Array<String> = throw Exception('TODO')
    let replacementDefault: Array<String> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    protected init(pattern: String, replacementAtStart: String, replacementBeforeVowel: String, replacementDefault: String) {
        throw Exception('TODO')
    }

    public func getPatternLength(): Int64 {
        throw Exception('TODO')
    }

    public func getReplacements(context: String, atStart: Bool): Array<String> {
        throw Exception('TODO')
    }

    private func isVowel(ch: Rune): Bool {
        throw Exception('TODO')
    }

    public func matches(context: String): Bool {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

