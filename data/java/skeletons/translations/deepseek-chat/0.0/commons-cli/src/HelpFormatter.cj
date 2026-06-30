// Package: commons_cli
package commons_cli

// Imports Begin
import std.io.ByteBuffer
import std.io.StringWriter
import stdx.crypto.x509.VerifyOption
// Imports End

public open class HelpFormatter {
    // Fields Begin
    static let DEFAULT_LONG_OPT_PREFIX: String = throw Exception('TODO')
    static let DEFAULT_LONG_OPT_SEPARATOR: String = throw Exception('TODO')
    static let DEFAULT_ARG_NAME: String = throw Exception('TODO')
    var defaultWidth: Int32 = throw Exception('TODO')
    var defaultLeftPad: Int32 = throw Exception('TODO')
    var defaultDescPad: Int32 = throw Exception('TODO')
    var defaultSyntaxPrefix: String = throw Exception('TODO')
    var defaultNewLine: String = throw Exception('TODO')
    var defaultOptPrefix: String = throw Exception('TODO')
    var defaultLongOptPrefix: String = throw Exception('TODO')
    var defaultArgName: String = throw Exception('TODO')
    var optionComparator: (Option, Option) -> Int64 = throw Exception('TODO')
    var longOptSeparator: String = throw Exception('TODO')
    static let DEFAULT_WIDTH: Int32 = throw Exception('TODO')
    static let DEFAULT_LEFT_PAD: Int32 = throw Exception('TODO')
    static let DEFAULT_DESC_PAD: Int32 = throw Exception('TODO')
    static let DEFAULT_SYNTAX_PREFIX: String = throw Exception('TODO')
    static let DEFAULT_OPT_PREFIX: String = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private func appendOption(buff: StringBuilder, option: Option, required: Bool): Unit {
        throw Exception('TODO')
    }

    private func appendOptionGroup(buff: StringBuilder, group: OptionGroup): Unit {
        throw Exception('TODO')
    }

    protected open func createPadding(len: Int32): String {
        throw Exception('TODO')
    }

    protected open func findWrapPos(text: String, width: Int32, startPos: Int32): Int32 {
        throw Exception('TODO')
    }

    public open func getArgName(): String {
        throw Exception('TODO')
    }

    public open func getDescPadding(): Int32 {
        throw Exception('TODO')
    }

    public open func getLeftPadding(): Int32 {
        throw Exception('TODO')
    }

    public open func getLongOptPrefix(): String {
        throw Exception('TODO')
    }

    public open func getLongOptSeparator(): String {
        throw Exception('TODO')
    }

    public open func getNewLine(): String {
        throw Exception('TODO')
    }

    public open func getOptionComparator<Option>(): (Option, Option) -> Int64 {
        throw Exception('TODO')
    }

    public open func getOptPrefix(): String {
        throw Exception('TODO')
    }

    public open func getSyntaxPrefix(): String {
        throw Exception('TODO')
    }

    public open func getWidth(): Int32 {
        throw Exception('TODO')
    }

    public open func printHelp0(width: Int32, cmdLineSyntax: String, header: String, options: Options, footer: String): Unit {
        throw Exception('TODO')
    }

    public open func printHelp1(width: Int32, cmdLineSyntax: String, header: String, options: Options, footer: String, autoUsage: Bool): Unit {
        throw Exception('TODO')
    }

    public open func printHelp2(pw: StringWriter<ByteBuffer>, width: Int32, cmdLineSyntax: String, header: String, options: Options, leftPad: Int32, descPad: Int32, footer: String): Unit {
        throw Exception('TODO')
    }

    public open func printHelp3(pw: StringWriter<ByteBuffer>, width: Int32, cmdLineSyntax: String, header: String, options: Options, leftPad: Int32, descPad: Int32, footer: String, autoUsage: Bool): Unit {
        throw Exception('TODO')
    }

    public open func printHelp4(cmdLineSyntax: String, options: Options): Unit {
        throw Exception('TODO')
    }

    public open func printHelp5(cmdLineSyntax: String, options: Options, autoUsage: Bool): Unit {
        throw Exception('TODO')
    }

    public open func printHelp6(cmdLineSyntax: String, header: String, options: Options, footer: String): Unit {
        throw Exception('TODO')
    }

    public open func printHelp7(cmdLineSyntax: String, header: String, options: Options, footer: String, autoUsage: Bool): Unit {
        throw Exception('TODO')
    }

    public open func printOptions(pw: StringWriter<ByteBuffer>, width: Int32, options: Options, leftPad: Int32, descPad: Int32): Unit {
        throw Exception('TODO')
    }

    public open func printUsage0(pw: StringWriter<ByteBuffer>, width: Int32, cmdLineSyntax: String): Unit {
        throw Exception('TODO')
    }

    public open func printUsage1(pw: StringWriter<ByteBuffer>, width: Int32, app: String, options: Options): Unit {
        throw Exception('TODO')
    }

    public open func printWrapped0(pw: StringWriter<ByteBuffer>, width: Int32, nextLineTabStop: Int32, text: String): Unit {
        throw Exception('TODO')
    }

    public open func printWrapped1(pw: StringWriter<ByteBuffer>, width: Int32, text: String): Unit {
        throw Exception('TODO')
    }

    protected open func renderOptions(sb: StringBuilder, width: Int32, options: Options, leftPad: Int32, descPad: Int32): StringBuilder {
        throw Exception('TODO')
    }

    protected open func renderWrappedText(sb: StringBuilder, width: Int32, nextLineTabStop: Int32, text: String): StringBuilder {
        throw Exception('TODO')
    }

    private func renderWrappedTextBlock(sb: StringBuilder, width: Int32, nextLineTabStop: Int32, text: String): StringWriter<ByteBuffer> {
        throw Exception('TODO')
    }

    protected open func rtrim(s: String): String {
        throw Exception('TODO')
    }

    public open func setArgName(name: String): Unit {
        throw Exception('TODO')
    }

    public open func setDescPadding(padding: Int32): Unit {
        throw Exception('TODO')
    }

    public open func setLeftPadding(padding: Int32): Unit {
        throw Exception('TODO')
    }

    public open func setLongOptPrefix(prefix: String): Unit {
        throw Exception('TODO')
    }

    public open func setLongOptSeparator(longOptSeparator_param: String): Unit {
        throw Exception('TODO')
    }

    public open func setNewLine(newline: String): Unit {
        throw Exception('TODO')
    }

    public open func setOptionComparator<Option>(comparator: (Option, Option) -> Int64): Unit {
        throw Exception('TODO')
    }

    public open func setOptPrefix(prefix: String): Unit {
        throw Exception('TODO')
    }

    public open func setSyntaxPrefix(prefix: String): Unit {
        throw Exception('TODO')
    }

    public open func setWidth(width: Int32): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

open class HelpFormatter_OptionComparator {
    // Fields Begin
    // Fields End

    // Methods Begin
    public open func compare(opt1: Option, opt2: Option): Int32 {
        throw Exception('TODO')
    }

    // Methods End
}

