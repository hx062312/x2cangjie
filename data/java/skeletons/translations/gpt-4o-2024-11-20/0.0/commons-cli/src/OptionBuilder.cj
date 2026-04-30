// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

class OptionBuilder {
    // Fields Begin
    static var longOption: String = throw Exception('TODO')
    static var description: String = throw Exception('TODO')
    static var argName: String = throw Exception('TODO')
    static var required: Bool = throw Exception('TODO')
    static var argCount: Int64 = throw Exception('TODO')
    static var type: Type<Any> = throw Exception('TODO')
    static var optionalArg: Bool = throw Exception('TODO')
    static var valueSeparator: Rune = throw Exception('TODO')
    static let INSTANCE: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func create(): Option {
        throw Exception('TODO')
    }

    public static func create(opt: Rune): Option {
        throw Exception('TODO')
    }

    public static func create(opt: String): Option {
        throw Exception('TODO')
    }

    public static func hasArg(): Any {
        throw Exception('TODO')
    }

    public static func hasArg(hasArg: Bool): Any {
        throw Exception('TODO')
    }

    public static func hasArgs(): Any {
        throw Exception('TODO')
    }

    public static func hasArgs(num: Int64): Any {
        throw Exception('TODO')
    }

    public static func hasOptionalArg(): Any {
        throw Exception('TODO')
    }

    public static func hasOptionalArgs(): Any {
        throw Exception('TODO')
    }

    public static func hasOptionalArgs(numArgs: Int64): Any {
        throw Exception('TODO')
    }

    public static func isRequired(): Any {
        throw Exception('TODO')
    }

    public static func isRequired(newRequired: Bool): Any {
        throw Exception('TODO')
    }

    private static func reset(): Unit {
        throw Exception('TODO')
    }

    public static func withArgName(name: String): Any {
        throw Exception('TODO')
    }

    public static func withDescription(newDescription: String): Any {
        throw Exception('TODO')
    }

    public static func withLongOpt(newLongopt: String): Any {
        throw Exception('TODO')
    }

    public static func withType(newType: Type<Any>): Any {
        throw Exception('TODO')
    }

    public static func withType(newType: Any): Any {
        throw Exception('TODO')
    }

    public static func withValueSeparator(): Any {
        throw Exception('TODO')
    }

    public static func withValueSeparator(sep: Rune): Any {
        throw Exception('TODO')
    }

    private init() {
        throw Exception('TODO')
    }

    // Methods End
}

