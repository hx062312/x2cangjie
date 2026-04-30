// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

open class MissingArgumentException <: ParseException {
    // Fields Begin
    static let serialVersionUID: Int64 = throw Exception('TODO')
    var option: Option = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(option: Option) {
        throw Exception('TODO')
    }

    public init(message: String) {
        throw Exception('TODO')
    }

    public func getOption(): Option {
        throw Exception('TODO')
    }

    // Methods End
}

