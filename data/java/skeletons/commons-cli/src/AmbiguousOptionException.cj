// Package: commons_cli
package commons_cli

// Imports Begin
import std.collection.*
import std.collection.ArrayList
// Imports End

public open class AmbiguousOptionException <: UnrecognizedOptionException {
    // Fields Begin
    var matchingOptions: ArrayList<String> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private static func createMessage(option_param: String, matchingOptions_param: ArrayList<String>): String {
        throw Exception('TODO')
    }

    public init(option_param: String, matchingOptions_param: ArrayList<String>) {
        super()
        throw Exception('TODO')
    }

    public open func getMatchingOptions(): ArrayList<String> {
        throw Exception('TODO')
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

