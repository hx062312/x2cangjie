// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

open class HelpFormatter {
    // Fields Begin
    static let DEFAULT_SYNTAX_PREFIX: String = throw Exception('TODO')
    static let DEFAULT_OPT_PREFIX: String = throw Exception('TODO')
    static let DEFAULT_LONG_OPT_PREFIX: String = throw Exception('TODO')
    static let DEFAULT_LONG_OPT_SEPARATOR: String = throw Exception('TODO')
    static let DEFAULT_ARG_NAME: String = throw Exception('TODO')
    var defaultWidth: Int64 = throw Exception('TODO')
    var defaultLeftPad: Int64 = throw Exception('TODO')
    var defaultDescPad: Int64 = throw Exception('TODO')
    var defaultSyntaxPrefix: String = throw Exception('TODO')
    var defaultNewLine: String = throw Exception('TODO')
    var defaultOptPrefix: String = throw Exception('TODO')
    var defaultLongOptPrefix: String = throw Exception('TODO')
    var defaultArgName: String = throw Exception('TODO')
    var optionComparator: Comparator<Option> = throw Exception('TODO')
    var longOptSeparator: String = throw Exception('TODO')
    static let DEFAULT_WIDTH: Int64 = throw Exception('TODO')
    static let DEFAULT_LEFT_PAD: Int64 = throw Exception('TODO')
    static let DEFAULT_DESC_PAD: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private func appendOption(buff: StringBuilder, option: Option, required: Bool): Unit {
        throw Exception('TODO')
    }

    private func appendOptionGroup(buff: StringBuilder, group: OptionGroup): Unit {
        throw Exception('TODO')
    }

    protected func createPadding(len: Int64): String {
        throw Exception('TODO')
    }

    protected func findWrapPos(text: String, width: Int64, startPos: Int64): Int64 {
        throw Exception('TODO')
    }

    public func getArgName(): String {
        throw Exception('TODO')
    }

    public func getDescPadding(): Int64 {
        throw Exception('TODO')
    }

    public func getLeftPadding(): Int64 {
        throw Exception('TODO')
    }

    public func getLongOptPrefix(): String {
        throw Exception('TODO')
    }

    public func getLongOptSeparator(): String {
        throw Exception('TODO')
    }

    public func getNewLine(): String {
        throw Exception('TODO')
    }

    public func getOptionComparator(): Comparator<Option> {
        throw Exception('TODO')
    }

    public func getOptPrefix(): String {
        throw Exception('TODO')
    }

    public func getSyntaxPrefix(): String {
        throw Exception('TODO')
    }

    public func getWidth(): Int64 {
        throw Exception('TODO')
    }

    public open func printHelp(width: Int64, cmdLineSyntax: String, header: String, options: Options, footer: String): Unit {
        throw Exception('TODO')
    }

    public open func printHelp(width: Int64, cmdLineSyntax: String, header: String, options: Options, footer: String, autoUsage: Bool): Unit {
        throw Exception('TODO')
    }

    public open func printHelp(pw: Any, width: Int64, cmdLineSyntax: String, header: String, options: Options, leftPad: Int64, descPad: Int64, footer: String): Unit {
        throw Exception('TODO')
    }

    public open func printHelp(pw: Any, width: Int64, cmdLineSyntax: String, header: String, options: Options, leftPad: Int64, descPad: Int64, footer: String, autoUsage: Bool): Unit {
        throw Exception('TODO')
    }

    public open func printHelp(cmdLineSyntax: String, options: Options): Unit {
        throw Exception('TODO')
    }

    public open func printHelp(cmdLineSyntax: String, options: Options, autoUsage: Bool): Unit {
        throw Exception('TODO')
    }

    public open func printHelp(cmdLineSyntax: String, header: String, options: Options, footer: String): Unit {
        throw Exception('TODO')
    }

    public open func printHelp(cmdLineSyntax: String, header: String, options: Options, footer: String, autoUsage: Bool): Unit {
        throw Exception('TODO')
    }

    public func printOptions(pw: Any, width: Int64, options: Options, leftPad: Int64, descPad: Int64): Unit {
        throw Exception('TODO')
    }

    public open func printUsage(pw: Any, width: Int64, cmdLineSyntax: String): Unit {
        throw Exception('TODO')
    }

    public open func printUsage(pw: Any, width: Int64, app: String, options: Options): Unit {
        throw Exception('TODO')
    }

    public open func printWrapped(pw: Any, width: Int64, nextLineTabStop: Int64, text: String): Unit {
        throw Exception('TODO')
    }

    public open func printWrapped(pw: Any, width: Int64, text: String): Unit {
        throw Exception('TODO')
    }

    protected func renderOptions(sb: StringBuilder, width: Int64, options: Options, leftPad: Int64, descPad: Int64): StringBuilder {
        throw Exception('TODO')
    }

    protected func renderWrappedText(sb: StringBuilder, width: Int64, nextLineTabStop: Int64, text: String): StringBuilder {
        throw Exception('TODO')
    }

    private func renderWrappedTextBlock(sb: StringBuilder, width: Int64, nextLineTabStop: Int64, text: String): Any {
        throw Exception('TODO')
    }

    protected func rtrim(s: String): String {
        throw Exception('TODO')
    }

    public func setArgName(name: String): Unit {
        throw Exception('TODO')
    }

    public func setDescPadding(padding: Int64): Unit {
        throw Exception('TODO')
    }

    public func setLeftPadding(padding: Int64): Unit {
        throw Exception('TODO')
    }

    public func setLongOptPrefix(prefix: String): Unit {
        throw Exception('TODO')
    }

    public func setLongOptSeparator(longOptSeparator: String): Unit {
        throw Exception('TODO')
    }

    public func setNewLine(newline: String): Unit {
        throw Exception('TODO')
    }

    public func setOptionComparator(comparator: Comparator<Option>): Unit {
        throw Exception('TODO')
    }

    public func setOptPrefix(prefix: String): Unit {
        throw Exception('TODO')
    }

    public func setSyntaxPrefix(prefix: String): Unit {
        throw Exception('TODO')
    }

    public func setWidth(width: Int64): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

open class OptionComparator <: Comparator<Option> & Serializable {
    // Fields Begin
    static let serialVersionUID: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public func compare(opt1: Option, opt2: Option): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

