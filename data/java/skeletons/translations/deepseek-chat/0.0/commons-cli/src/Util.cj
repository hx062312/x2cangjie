// Package: commons_cli
package commons_cli

// Imports Begin

// Imports End

class Util {
    // Fields Begin
    static let EMPTY_STRING_ARRAY: Array<String> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    static func stripLeadingAndTrailingQuotes(str: String): String {
        throw Exception('TODO')
    }

    static func stripLeadingHyphens(str: String): String {
                if (str == "") {
        return ""
        }
        if (str.startsWith("--")) {
        return str[2..]
        }
        if (str.startsWith("-")) {
        return str[1..]
        }
        return str
    }

    // Methods End
}

