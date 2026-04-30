// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

open class CommandLine <: Serializable {
    // Fields Begin
    static let serialVersionUID: Int64 = throw Exception('TODO')
    let args: ArrayList<String> = throw Exception('TODO')
    let options: ArrayList<Option> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    protected init() {
        throw Exception('TODO')
    }

    protected func addArg(arg: String): Unit {
        throw Exception('TODO')
    }

    protected func addOption(opt: Option): Unit {
        throw Exception('TODO')
    }

    public func getArgList(): ArrayList<String> {
        throw Exception('TODO')
    }

    public func getArgs(): Array<String> {
        throw Exception('TODO')
    }

    public open func getOptionObject(opt: Rune): Any {
        throw Exception('TODO')
    }

    public open func getOptionObject(opt: String): Any {
        throw Exception('TODO')
    }

    public open func getOptionProperties(option: Option): HashMap<String, String> {
        throw Exception('TODO')
    }

    public open func getOptionProperties(opt: String): HashMap<String, String> {
        throw Exception('TODO')
    }

    public func getOptions(): Array<Option> {
        throw Exception('TODO')
    }

    public open func getOptionValue(opt: Rune): String {
        throw Exception('TODO')
    }

    public open func getOptionValue(opt: Rune, defaultValue: String): String {
        throw Exception('TODO')
    }

    public open func getOptionValue(option: Option): String {
        throw Exception('TODO')
    }

    public open func getOptionValue(option: Option, defaultValue: String): String {
        throw Exception('TODO')
    }

    public open func getOptionValue(opt: String): String {
        throw Exception('TODO')
    }

    public open func getOptionValue(opt: String, defaultValue: String): String {
        throw Exception('TODO')
    }

    public open func getOptionValues(opt: Rune): Array<String> {
        throw Exception('TODO')
    }

    public open func getOptionValues(option: Option): Array<String> {
        throw Exception('TODO')
    }

    public open func getOptionValues(opt: String): Array<String> {
        throw Exception('TODO')
    }

    public open func getParsedOptionValue(opt: Rune): Any {
        throw Exception('TODO')
    }

    public open func getParsedOptionValue(option: Option): Any {
        throw Exception('TODO')
    }

    public open func getParsedOptionValue(opt: String): Any {
        throw Exception('TODO')
    }

    public open func hasOption(opt: Rune): Bool {
        throw Exception('TODO')
    }

    public open func hasOption(opt: Option): Bool {
        throw Exception('TODO')
    }

    public open func hasOption(opt: String): Bool {
        throw Exception('TODO')
    }

    public func iterator(): Iterator<Option> {
        throw Exception('TODO')
    }

    private func resolveOption(opt: String): Option {
        throw Exception('TODO')
    }

    // Methods End
}

class Builder {
    // Fields Begin
    let commandLine: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public func addArg(arg: String): Any {
        throw Exception('TODO')
    }

    public func addOption(opt: Option): Any {
        throw Exception('TODO')
    }

    public func build(): Any {
        throw Exception('TODO')
    }

    // Methods End
}

