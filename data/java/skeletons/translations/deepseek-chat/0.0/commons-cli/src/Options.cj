// Package: commons_cli
package commons_cli

// Imports Begin
import commons_cli.runtime.AnyHashable
import std.collection.*
import std.collection.ArrayList
import std.collection.HashMap
import stdx.crypto.x509.VerifyOption
// Imports End

public open class Options {
    // Fields Begin
    var shortOpts: HashMap<String, Option> = throw Exception('TODO')
    var longOpts: HashMap<String, Option> = throw Exception('TODO')
    var requiredOpts: ArrayList<Any> = throw Exception('TODO')
    var optionGroups: HashMap<String, OptionGroup> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public open func addOption0(opt: Option): Options {
        throw Exception('TODO')
    }

    public open func addOption1(opt: String, hasArg: Bool, description: String): Options {
        throw Exception('TODO')
    }

    public open func addOption2(opt: String, description: String): Options {
                addOption3(opt, "", false, description)
        return this
    }

    public open func addOption3(opt: String, longOpt: String, hasArg: Bool, description: String): Options {
        throw Exception('TODO')
    }

    public open func addOptionGroup(group: OptionGroup): Options {
        throw Exception('TODO')
    }

    public open func addRequiredOption(opt: String, longOpt: String, hasArg: Bool, description: String): Options {
        throw Exception('TODO')
    }

    public open func getMatchingOptions(opt: String): ArrayList<String> {
        throw Exception('TODO')
    }

    public open func getOption(opt: String): Option {
        throw Exception('TODO')
    }

    public open func getOptionGroup(opt: Option): OptionGroup {
        throw Exception('TODO')
    }

    public open func getOptionGroups<OptionGroup>(): ArrayList<OptionGroup> {
        throw Exception('TODO')
    }

    public open func getOptions<Option>(): ArrayList<Option> {
        throw Exception('TODO')
    }

    public open func getRequiredOptions(): ArrayList<Any> {
        throw Exception('TODO')
    }

    public open func hasLongOption(opt: String): Bool {
        throw Exception('TODO')
    }

    public open func hasOption(opt: String): Bool {
        throw Exception('TODO')
    }

    public open func hasShortOption(opt: String): Bool {
        throw Exception('TODO')
    }

    public open func helpOptions<Option>(): ArrayList<Option> {
        throw Exception('TODO')
    }

    public open func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

