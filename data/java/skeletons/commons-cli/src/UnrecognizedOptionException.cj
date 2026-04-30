// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

open class UnrecognizedOptionException <: ParseException {
    // Fields Begin
    static let serialVersionUID: Int64 = throw Exception('TODO')
    let option: String = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(message: String) {
        throw Exception('TODO')
    }

    public init(message: String, option: String) {
        throw Exception('TODO')
    }

    public func getOption(): String {
        throw Exception('TODO')
    }

    // Methods End
}

