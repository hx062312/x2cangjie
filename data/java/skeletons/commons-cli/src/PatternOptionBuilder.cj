// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

open class PatternOptionBuilder {
    // Fields Begin
    static let FILES_VALUE: Type<Array<Any>> = throw Exception('TODO')
    static let URL_VALUE: Type<Any> = throw Exception('TODO')
    static let STRING_VALUE: Type<String> = throw Exception('TODO')
    static let OBJECT_VALUE: Type<Any> = throw Exception('TODO')
    static let NUMBER_VALUE: Type<Number> = throw Exception('TODO')
    static let DATE_VALUE: Type<Any> = throw Exception('TODO')
    static let CLASS_VALUE: Type<Any> = throw Exception('TODO')
    static let EXISTING_FILE_VALUE: Type<Any> = throw Exception('TODO')
    static let FILE_VALUE: Type<Any> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func getValueClass(ch: Rune): Any {
        throw Exception('TODO')
    }

    public static func isValueCode(ch: Rune): Bool {
        throw Exception('TODO')
    }

    public static func parsePattern(pattern: String): Options {
        throw Exception('TODO')
    }

    // Methods End
}

