// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

open class AlreadySelectedException <: ParseException {
    // Fields Begin
    static let serialVersionUID: Int64 = throw Exception('TODO')
    let group: OptionGroup = throw Exception('TODO')
    let option: Option = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(group: OptionGroup, option: Option) {
        throw Exception('TODO')
    }

    public init(message: String) {
        throw Exception('TODO')
    }

    private init(message: String, group: OptionGroup, option: Option) {
        throw Exception('TODO')
    }

    public func getOption(): Option {
        throw Exception('TODO')
    }

    public func getOptionGroup(): OptionGroup {
        throw Exception('TODO')
    }

    // Methods End
}

