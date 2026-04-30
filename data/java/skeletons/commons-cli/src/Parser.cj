// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

abstract class Parser <: CommandLineParser {
    // Fields Begin
    var cmd: Any = throw Exception('TODO')
    var options: Options = throw Exception('TODO')
    var requiredOptions: ArrayList<Any> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    protected func checkRequiredOptions(): Unit {
        throw Exception('TODO')
    }

    protected func flatten(opts: Options, arguments: Array<String>, stopAtNonOption: Bool): Array<String> {
        throw Exception('TODO')
    }

    protected func getOptions(): Options {
        throw Exception('TODO')
    }

    protected func getRequiredOptions(): ArrayList<Any> {
        throw Exception('TODO')
    }

    public open func parse(options: Options, arguments: Array<String>): Any {
        throw Exception('TODO')
    }

    public open func parse(options: Options, arguments: Array<String>, stopAtNonOption: Bool): Any {
        throw Exception('TODO')
    }

    public open func parse(options: Options, arguments: Array<String>, properties: HashMap<String, String>): Any {
        throw Exception('TODO')
    }

    public open func parse(options: Options, arguments: Array<String>, properties: HashMap<String, String>, stopAtNonOption: Bool): Any {
        throw Exception('TODO')
    }

    public func processArgs(opt: Option, iter: ListIterator<String>): Unit {
        throw Exception('TODO')
    }

    protected func processOption(arg: String, iter: ListIterator<String>): Unit {
        throw Exception('TODO')
    }

    protected func processProperties(properties: HashMap<String, String>): Unit {
        throw Exception('TODO')
    }

    protected func setOptions(options: Options): Unit {
        throw Exception('TODO')
    }

    private func updateRequiredOptions(opt: Option): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

