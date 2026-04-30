// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

open class PosixParser <: Parser {
    // Fields Begin
    let tokens: ArrayList<String> = throw Exception('TODO')
    var eatTheRest: Bool = throw Exception('TODO')
    var currentOption: Option = throw Exception('TODO')
    var options: Options = throw Exception('TODO')
    // Fields End

    // Methods Begin
    protected func burstToken(token: String, stopAtNonOption: Bool): Unit {
        throw Exception('TODO')
    }

    protected func flatten(options: Options, arguments: Array<String>, stopAtNonOption: Bool): Array<String> {
        throw Exception('TODO')
    }

    private func gobble(iter: Iterator<String>): Unit {
        throw Exception('TODO')
    }

    private func init(): Unit {
        throw Exception('TODO')
    }

    private func processNonOptionToken(value: String, stopAtNonOption: Bool): Unit {
        throw Exception('TODO')
    }

    private func processOptionToken(token: String, stopAtNonOption: Bool): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

