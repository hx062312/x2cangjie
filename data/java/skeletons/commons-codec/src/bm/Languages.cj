// Package: commons_codec.bm
package commons_codec.bm

// Imports Begin
// Imports End

open class Languages {
    // Fields Begin
    static let ANY: String = throw Exception('TODO')
    static let LANGUAGES: HashMap<Any, Any> = throw Exception('TODO')
    let languages: Set<String> = throw Exception('TODO')
    static let NO_LANGUAGES: Any = throw Exception('TODO')
    static let ANY_LANGUAGE: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func getInstance(nameType: Any): Any {
        throw Exception('TODO')
    }

    public static func getInstance(languagesResourceName: String): Any {
        throw Exception('TODO')
    }

    private static func langResourceName(nameType: Any): String {
        throw Exception('TODO')
    }

    private init(languages: Set<String>) {
        throw Exception('TODO')
    }

    public func getLanguages(): Set<String> {
        throw Exception('TODO')
    }

    // Methods End
}

abstract open class LanguageSet {
    // Fields Begin
    // Fields End

    // Methods Begin
    public static func from(langs: Set<String>): Any {
        throw Exception('TODO')
    }

    public func contains(language: String): Bool {
        throw Exception('TODO')
    }

    public func getAny(): String {
        throw Exception('TODO')
    }

    public func isEmpty(): Bool {
        throw Exception('TODO')
    }

    public func isSingleton(): Bool {
        throw Exception('TODO')
    }

    public func restrictTo(other: Any): Any {
        throw Exception('TODO')
    }

    func merge(other: Any): Any {
        throw Exception('TODO')
    }

    // Methods End
}

class SomeLanguages <: LanguageSet {
    // Fields Begin
    let languages: Set<String> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private init(languages: Set<String>) {
        throw Exception('TODO')
    }

    public func contains(language: String): Bool {
        throw Exception('TODO')
    }

    public func getAny(): String {
        throw Exception('TODO')
    }

    public func getLanguages(): Set<String> {
        throw Exception('TODO')
    }

    public func isEmpty(): Bool {
        throw Exception('TODO')
    }

    public func isSingleton(): Bool {
        throw Exception('TODO')
    }

    public func restrictTo(other: Any): Any {
        throw Exception('TODO')
    }

    public func merge(other: Any): Any {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

