// Package: commons_codec.bm
package commons_codec.bm

// Imports Begin
// Imports End

open class Lang {
    // Fields Begin
    let languages: Any = throw Exception('TODO')
    let rules: ArrayList<Any> = throw Exception('TODO')
    static let Langs: HashMap<Any, Any> = throw Exception('TODO')
    static let LANGUAGE_RULES_RN: String = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func instance(nameType: Any): Any {
        throw Exception('TODO')
    }

    public static func loadFromResource(languageRulesResourceName: String, languages: Any): Any {
        throw Exception('TODO')
    }

    private init(rules: ArrayList<Any>, languages: Any) {
        throw Exception('TODO')
    }

    public func guessLanguage(text: String): String {
        throw Exception('TODO')
    }

    public func guessLanguages(input: String): Any {
        throw Exception('TODO')
    }

    // Methods End
}

class LangRule {
    // Fields Begin
    let acceptOnMatch: Bool = throw Exception('TODO')
    let languages: Set<String> = throw Exception('TODO')
    let pattern: Regex = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private init(pattern: Regex, languages: Set<String>, acceptOnMatch: Bool) {
        throw Exception('TODO')
    }

    public func matches(txt: String): Bool {
        throw Exception('TODO')
    }

    // Methods End
}

