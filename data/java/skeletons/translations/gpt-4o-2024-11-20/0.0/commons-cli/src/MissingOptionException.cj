// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

open class MissingOptionException <: ParseException {
    // Fields Begin
    static let serialVersionUID: Int64 = throw Exception('TODO')
    var missingOptions: ArrayList<Any> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private static func createMessage(missingOptions: ArrayList<Any>): String {
        throw Exception('TODO')
    }

    public init(missingOptions: ArrayList<Any>) {
        throw Exception('TODO')
    }

    public init(message: String) {
        throw Exception('TODO')
    }

    public func getMissingOptions(): ArrayList<Any> {
        throw Exception('TODO')
    }

    // Methods End
}

