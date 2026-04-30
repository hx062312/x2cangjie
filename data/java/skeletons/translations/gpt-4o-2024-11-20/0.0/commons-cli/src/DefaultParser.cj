// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

open class DefaultParser <: CommandLineParser {
    // Fields Begin
    var cmd: Any = throw Exception('TODO')
    var options: Options = throw Exception('TODO')
    var stopAtNonOption: Bool = throw Exception('TODO')
    var currentToken: String = throw Exception('TODO')
    var currentOption: Option = throw Exception('TODO')
    var skipParsing: Bool = throw Exception('TODO')
    var expectedOpts: ArrayList<Any> = throw Exception('TODO')
    let allowPartialMatching: Bool = throw Exception('TODO')
    let stripLeadingAndTrailingQuotes: Bool = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func builder(): Any {
        throw Exception('TODO')
    }

    public init() {
        throw Exception('TODO')
    }

    public init(allowPartialMatching: Bool) {
        throw Exception('TODO')
    }

    private init(allowPartialMatching: Bool, stripLeadingAndTrailingQuotes: Bool) {
        throw Exception('TODO')
    }

    private func checkRequiredArgs(): Unit {
        throw Exception('TODO')
    }

    protected func checkRequiredOptions(): Unit {
        throw Exception('TODO')
    }

    private func getLongPrefix(token: String): String {
        throw Exception('TODO')
    }

    private func getMatchingLongOptions(token: String): ArrayList<String> {
        throw Exception('TODO')
    }

    protected func handleConcatenatedOptions(token: String): Unit {
        throw Exception('TODO')
    }

    private func handleLongOption(token: String): Unit {
        throw Exception('TODO')
    }

    private func handleLongOptionWithEqual(token: String): Unit {
        throw Exception('TODO')
    }

    private func handleLongOptionWithoutEqual(token: String): Unit {
        throw Exception('TODO')
    }

    private func handleOption(option: Option): Unit {
        throw Exception('TODO')
    }

    private func handleProperties(properties: HashMap<String, String>): Unit {
        throw Exception('TODO')
    }

    private func handleShortAndLongOption(token: String): Unit {
        throw Exception('TODO')
    }

    private func handleToken(token: String): Unit {
        throw Exception('TODO')
    }

    private func handleUnknownToken(token: String): Unit {
        throw Exception('TODO')
    }

    private func isArgument(token: String): Bool {
        throw Exception('TODO')
    }

    private func isJavaProperty(token: String): Bool {
        throw Exception('TODO')
    }

    private func isLongOption(token: String): Bool {
        throw Exception('TODO')
    }

    private func isNegativeNumber(token: String): Bool {
        throw Exception('TODO')
    }

    private func isOption(token: String): Bool {
        throw Exception('TODO')
    }

    private func isShortOption(token: String): Bool {
        throw Exception('TODO')
    }

    public open func parse(options: Options, arguments: Array<String>): Any {
        throw Exception('TODO')
    }

    public open func parse(options: Options, arguments: Array<String>, stopAtNonOption: Bool): Any {
        throw Exception('TODO')
    }

    public open func parse(options: Options, arguments: Array<String>, properties: HashMap<String, String>): Any {
        throw Exception('TODO')
    }

    public open func parse(options: Options, arguments: Array<String>, properties: HashMap<String, String>, stopAtNonOption: Bool): Any {
        throw Exception('TODO')
    }

    private func stripLeadingAndTrailingQuotesDefaultOff(token: String): String {
        throw Exception('TODO')
    }

    private func stripLeadingAndTrailingQuotesDefaultOn(token: String): String {
        throw Exception('TODO')
    }

    private func updateRequiredOptions(option: Option): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

class Builder {
    // Fields Begin
    var allowPartialMatching: Bool = throw Exception('TODO')
    var stripLeadingAndTrailingQuotes: Bool = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private init() {
        throw Exception('TODO')
    }

    public func build(): Any {
        throw Exception('TODO')
    }

    public func setAllowPartialMatching(allowPartialMatching: Bool): Any {
        throw Exception('TODO')
    }

    public func setStripLeadingAndTrailingQuotes(stripLeadingAndTrailingQuotes: Bool): Any {
        throw Exception('TODO')
    }

    // Methods End
}

