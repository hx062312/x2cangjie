// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

open class OptionGroup <: Serializable {
    // Fields Begin
    static let serialVersionUID: Int64 = throw Exception('TODO')
    let optionMap: HashMap<String, Option> = throw Exception('TODO')
    var selected: String = throw Exception('TODO')
    var required: Bool = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public func addOption(option: Option): OptionGroup {
        throw Exception('TODO')
    }

    public func getNames(): Collection<String> {
        throw Exception('TODO')
    }

    public func getOptions(): Collection<Option> {
        throw Exception('TODO')
    }

    public func getSelected(): String {
        throw Exception('TODO')
    }

    public func isRequired(): Bool {
        throw Exception('TODO')
    }

    public func setRequired(required: Bool): Unit {
        throw Exception('TODO')
    }

    public func setSelected(option: Option): Unit {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

