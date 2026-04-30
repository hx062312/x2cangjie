// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

open class AmbiguousOptionException <: UnrecognizedOptionException {
    // Fields Begin
    static let serialVersionUID: Int64 = throw Exception('TODO')
    let matchingOptions: Collection<String> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private static func createMessage(option: String, matchingOptions: Collection<String>): String {
        throw Exception('TODO')
    }

    public init(option: String, matchingOptions: Collection<String>) {
        throw Exception('TODO')
    }

    public func getMatchingOptions(): Collection<String> {
        throw Exception('TODO')
    }

    // Methods End
}

