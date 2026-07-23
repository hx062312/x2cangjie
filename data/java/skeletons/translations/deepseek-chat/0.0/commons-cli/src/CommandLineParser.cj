// Package: commons_cli
package commons_cli

// Imports Begin

// Imports End

public interface CommandLineParser {
    // Methods Begin
    func parse0(options: Options, arguments: Array<String>): CommandLine {
        throw Exception('TODO')
    }

    func parse1(options: Options, arguments: Array<String>, stopAtNonOption: Bool): CommandLine {
                throw Exception("TODO")
    }

    // Methods End
}

