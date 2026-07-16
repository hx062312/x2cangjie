// Package: commons_cli
package commons_cli

// Imports Begin

// Imports End

class OptionValidator {
    // Fields Begin
    // Fields End

    // Methods Begin
    private static func isValidChar(c: Rune): Bool {
        throw Exception('TODO')
    }

    private static func isValidOpt(c: Rune): Bool {
        throw Exception('TODO')
    }

    static func validate(option: String): String {
                if (option == "") {
        return option
        }
        if (option.size == 1) {
        let ch: Rune = Rune(option[0])
        if (!isValidOpt(ch)) {
        throw IllegalArgumentException("Illegal option name '" + ch.toString() + "'")
        }
        } else {
        for (ch in option.runes()) {
        if (!isValidChar(ch)) {
        throw IllegalArgumentException("The option '" + option + "' contains an illegal character : '" + ch.toString() + "'")
        }
        }
        }
        return option
    }

    // Methods End
}

