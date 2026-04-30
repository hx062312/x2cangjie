// Package: commons_codec.net
package commons_codec.net

// Imports Begin
// Imports End

open class QuotedPrintableCodec <: BinaryEncoder & BinaryDecoder & StringEncoder & StringDecoder {
    // Fields Begin
    static let SAFE_LENGTH: Int64 = throw Exception('TODO')
    let charset: Any = throw Exception('TODO')
    let strict: Bool = throw Exception('TODO')
    static let PRINTABLE_CHARS: Any = throw Exception('TODO')
    static let ESCAPE_CHAR: Int8 = throw Exception('TODO')
    static let TAB: Int8 = throw Exception('TODO')
    static let SPACE: Int8 = throw Exception('TODO')
    static let CR: Int8 = throw Exception('TODO')
    static let LF: Int8 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public init(strict: Bool) {
        throw Exception('TODO')
    }

    public init(charset: Any) {
        throw Exception('TODO')
    }

    public init(charset: Any, strict: Bool) {
        throw Exception('TODO')
    }

    public init(charsetName: String) {
        throw Exception('TODO')
    }

    private static func encodeQuotedPrintable(b: Int64, buffer: Any): Int64 {
        throw Exception('TODO')
    }

    private static func getUnsignedOctet(index: Int64, bytes: Array<Int8>): Int64 {
        throw Exception('TODO')
    }

    private static func encodeByte(b: Int64, encode: Bool, buffer: Any): Int64 {
        throw Exception('TODO')
    }

    private static func isWhitespace(b: Int64): Bool {
        throw Exception('TODO')
    }

    public static func encodeQuotedPrintable(printable: Any, bytes: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public static func encodeQuotedPrintable(printable: Any, bytes: Array<Int8>, strict: Bool): Array<Int8> {
        throw Exception('TODO')
    }

    public static func decodeQuotedPrintable(bytes: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public open func encode(bytes: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public open func decode(bytes: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public open func encode(sourceStr: String): String {
        throw Exception('TODO')
    }

    public open func decode(sourceStr: String, sourceCharset: Any): String {
        throw Exception('TODO')
    }

    public open func decode(sourceStr: String, sourceCharset: String): String {
        throw Exception('TODO')
    }

    public open func decode(sourceStr: String): String {
        throw Exception('TODO')
    }

    public open func encode(obj: Any): Any {
        throw Exception('TODO')
    }

    public open func decode(obj: Any): Any {
        throw Exception('TODO')
    }

    public func getCharset(): Any {
        throw Exception('TODO')
    }

    public func getDefaultCharset(): String {
        throw Exception('TODO')
    }

    public open func encode(sourceStr: String, sourceCharset: Any): String {
        throw Exception('TODO')
    }

    public open func encode(sourceStr: String, sourceCharset: String): String {
        throw Exception('TODO')
    }

    // Methods End
}

