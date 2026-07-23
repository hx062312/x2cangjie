// Package: commons_cli
package commons_cli

// Imports Begin
import commons_cli.runtime.AnyHashable
import std.collection.*
import std.collection.ArrayList
import std.collection.HashMap
import stdx.crypto.x509.VerifyOption
// Imports End

public abstract class Parser <: CommandLineParser {
    // Fields Begin
    var cmd: CommandLine = throw Exception('TODO')
    var options: Options = throw Exception('TODO')
    var requiredOptions: ArrayList<Any> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    protected open func checkRequiredOptions(): Unit {
        throw Exception('TODO')
    }

    protected open func flatten(opts: Options, arguments: Array<String>, stopAtNonOption: Bool): Array<String> {
        throw Exception('TODO')
    }

    protected open func getOptions(): Options {
        throw Exception('TODO')
    }

    protected open func getRequiredOptions(): ArrayList<Any> {
        throw Exception('TODO')
    }

    public open func parse0(options_param: Options, arguments: Array<String>): CommandLine {
        throw Exception('TODO')
    }

    public open func parse1(options_param: Options, arguments: Array<String>, stopAtNonOption: Bool): CommandLine {
        throw Exception('TODO')
    }

    public open func parse2(options_param: Options, arguments: Array<String>, properties: HashMap<AnyHashable, Any>): CommandLine {
                return parse3(options_param, arguments, properties, false)
    }

    public open func parse3(options_param: Options, arguments: Array<String>, properties: HashMap<AnyHashable, Any>, stopAtNonOption: Bool): CommandLine {
        throw Exception('TODO')
    }

    public open func processArgs(opt: Option, iter: Iterator<String>): Unit {
        throw Exception('TODO')
    }

    protected open func processOption(arg: String, iter: Iterator<String>): Unit {
        throw Exception('TODO')
    }

    protected open func processProperties(properties: HashMap<AnyHashable, Any>): Unit {
        throw Exception('TODO')
    }

    protected open func setOptions(options_param: Options): Unit {
        throw Exception('TODO')
    }

    private func updateRequiredOptions(opt: Option): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

