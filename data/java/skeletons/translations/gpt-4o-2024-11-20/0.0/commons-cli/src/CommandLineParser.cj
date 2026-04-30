// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

interface CommandLineParser {
    // Fields Begin
    // Fields End

    // Methods Begin
    open func parse(options: Options, arguments: Array<String>): Any {
        throw Exception('TODO')
    }

    open func parse(options: Options, arguments: Array<String>, stopAtNonOption: Bool): Any {
        throw Exception('TODO')
    }

    // Methods End
}

