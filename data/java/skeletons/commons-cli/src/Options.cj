// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

open class Options <: Serializable {
    // Fields Begin
    static let serialVersionUID: Int64 = throw Exception('TODO')
    let shortOpts: HashMap<String, Option> = throw Exception('TODO')
    let longOpts: HashMap<String, Option> = throw Exception('TODO')
    let requiredOpts: ArrayList<Any> = throw Exception('TODO')
    let optionGroups: HashMap<String, OptionGroup> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public open func addOption(opt: Option): Options {
        throw Exception('TODO')
    }

    public open func addOption(opt: String, hasArg: Bool, description: String): Options {
        throw Exception('TODO')
    }

    public open func addOption(opt: String, description: String): Options {
        throw Exception('TODO')
    }

    public open func addOption(opt: String, longOpt: String, hasArg: Bool, description: String): Options {
        throw Exception('TODO')
    }

    public func addOptionGroup(group: OptionGroup): Options {
        throw Exception('TODO')
    }

    public func addRequiredOption(opt: String, longOpt: String, hasArg: Bool, description: String): Options {
        throw Exception('TODO')
    }

    public func getMatchingOptions(opt: String): ArrayList<String> {
        throw Exception('TODO')
    }

    public func getOption(opt: String): Option {
        throw Exception('TODO')
    }

    public func getOptionGroup(opt: Option): OptionGroup {
        throw Exception('TODO')
    }

    func getOptionGroups(): Collection<OptionGroup> {
        throw Exception('TODO')
    }

    public func getOptions(): Collection<Option> {
        throw Exception('TODO')
    }

    public func getRequiredOptions(): ArrayList<Any> {
        throw Exception('TODO')
    }

    public func hasLongOption(opt: String): Bool {
        throw Exception('TODO')
    }

    public func hasOption(opt: String): Bool {
        throw Exception('TODO')
    }

    public func hasShortOption(opt: String): Bool {
        throw Exception('TODO')
    }

    func helpOptions(): ArrayList<Option> {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

