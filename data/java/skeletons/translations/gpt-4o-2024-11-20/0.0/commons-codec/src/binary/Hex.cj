// Package: commons_codec.binary
package commons_codec.binary

// Imports Begin
// Imports End

open class Hex <: BinaryEncoder & BinaryDecoder {
    // Fields Begin
    let charset: Any = throw Exception('TODO')
    static let DEFAULT_CHARSET: Any = throw Exception('TODO')
    static let DEFAULT_CHARSET_NAME: String = throw Exception('TODO')
    static let DIGITS_LOWER: Array<Rune> = throw Exception('TODO')
    static let DIGITS_UPPER: Array<Rune> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func decodeHex(data: Array<Rune>): Array<Int8> {
        throw Exception('TODO')
    }

    public static func decodeHex(data: Array<Rune>, out: Array<Int8>, outOffset: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func decodeHex(data: String): Array<Int8> {
        throw Exception('TODO')
    }

    public static func encodeHex(data: Array<Int8>): Array<Rune> {
        throw Exception('TODO')
    }

    public static func encodeHex(data: Array<Int8>, toLowerCase: Bool): Array<Rune> {
        throw Exception('TODO')
    }

    protected static func encodeHex(data: Array<Int8>, toDigits: Array<Rune>): Array<Rune> {
        throw Exception('TODO')
    }

    public static func encodeHex(data: Array<Int8>, dataOffset: Int64, dataLen: Int64, toLowerCase: Bool): Array<Rune> {
        throw Exception('TODO')
    }

    public static func encodeHex(data: Array<Int8>, dataOffset: Int64, dataLen: Int64, toLowerCase: Bool, out: Array<Rune>, outOffset: Int64): Unit {
        throw Exception('TODO')
    }

    private static func encodeHex(data: Array<Int8>, dataOffset: Int64, dataLen: Int64, toDigits: Array<Rune>, out: Array<Rune>, outOffset: Int64): Unit {
        throw Exception('TODO')
    }

    public static func encodeHex(data: ByteBuffer): Array<Rune> {
        throw Exception('TODO')
    }

    public static func encodeHex(data: ByteBuffer, toLowerCase: Bool): Array<Rune> {
        throw Exception('TODO')
    }

    protected static func encodeHex(byteBuffer: ByteBuffer, toDigits: Array<Rune>): Array<Rune> {
        throw Exception('TODO')
    }

    public static func encodeHexString(data: Array<Int8>): String {
        throw Exception('TODO')
    }

    public static func encodeHexString(data: Array<Int8>, toLowerCase: Bool): String {
        throw Exception('TODO')
    }

    public static func encodeHexString(data: ByteBuffer): String {
        throw Exception('TODO')
    }

    public static func encodeHexString(data: ByteBuffer, toLowerCase: Bool): String {
        throw Exception('TODO')
    }

    private static func toByteArray(byteBuffer: ByteBuffer): Array<Int8> {
        throw Exception('TODO')
    }

    protected static func toDigit(ch: Rune, index: Int64): Int64 {
        throw Exception('TODO')
    }

    public init() {
        throw Exception('TODO')
    }

    public init(charset: Any) {
        throw Exception('TODO')
    }

    public init(charsetName: String) {
        throw Exception('TODO')
    }

    public open func decode(array: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public open func decode(buffer: ByteBuffer): Array<Int8> {
        throw Exception('TODO')
    }

    public open func decode(object: Any): Any {
        throw Exception('TODO')
    }

    public open func encode(array: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public open func encode(array: ByteBuffer): Array<Int8> {
        throw Exception('TODO')
    }

    public open func encode(object: Any): Any {
        throw Exception('TODO')
    }

    public func getCharset(): Any {
        throw Exception('TODO')
    }

    public func getCharsetName(): String {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

