// Package: commons_codec.binary
package commons_codec.binary

// Imports Begin
// Imports End

open class BinaryCodec <: BinaryDecoder & BinaryEncoder {
    // Fields Begin
    static let EMPTY_CHAR_ARRAY: Array<Rune> = throw Exception('TODO')
    static let EMPTY_BYTE_ARRAY: Array<Int8> = throw Exception('TODO')
    static let BIT_0: Int64 = throw Exception('TODO')
    static let BIT_1: Int64 = throw Exception('TODO')
    static let BIT_2: Int64 = throw Exception('TODO')
    static let BIT_3: Int64 = throw Exception('TODO')
    static let BIT_4: Int64 = throw Exception('TODO')
    static let BIT_5: Int64 = throw Exception('TODO')
    static let BIT_6: Int64 = throw Exception('TODO')
    static let BIT_7: Int64 = throw Exception('TODO')
    static let BITS: Array<Int64> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func fromAscii(ascii: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public static func fromAscii(ascii: Array<Rune>): Array<Int8> {
        throw Exception('TODO')
    }

    private static func isEmpty(array: Array<Int8>): Bool {
        throw Exception('TODO')
    }

    public static func toAsciiBytes(raw: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public static func toAsciiChars(raw: Array<Int8>): Array<Rune> {
        throw Exception('TODO')
    }

    public static func toAsciiString(raw: Array<Int8>): String {
        throw Exception('TODO')
    }

    public open func decode(ascii: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public open func decode(ascii: Any): Any {
        throw Exception('TODO')
    }

    public open func encode(raw: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public open func encode(raw: Any): Any {
        throw Exception('TODO')
    }

    public func toByteArray(ascii: String): Array<Int8> {
        throw Exception('TODO')
    }

    // Methods End
}

