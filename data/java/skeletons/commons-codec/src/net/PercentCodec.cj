// Package: commons_codec.net
package commons_codec.net

// Imports Begin
// Imports End

open class PercentCodec <: BinaryEncoder & BinaryDecoder {
    // Fields Begin
    static let ESCAPE_CHAR: Int8 = throw Exception('TODO')
    let alwaysEncodeChars: Any = throw Exception('TODO')
    let plusForSpace: Bool = throw Exception('TODO')
    var alwaysEncodeCharsMin: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public init(alwaysEncodeChars: Array<Int8>, plusForSpace: Bool) {
        throw Exception('TODO')
    }

    private func insertAlwaysEncodeChars(alwaysEncodeCharsArray: Array<Int8>): Unit {
        throw Exception('TODO')
    }

    private func insertAlwaysEncodeChar(b: Int8): Unit {
        throw Exception('TODO')
    }

    public open func encode(bytes: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    private func doEncode(bytes: Array<Int8>, expectedLength: Int64, willEncode: Bool): Array<Int8> {
        throw Exception('TODO')
    }

    private func expectedEncodingBytes(bytes: Array<Int8>): Int64 {
        throw Exception('TODO')
    }

    private func containsSpace(bytes: Array<Int8>): Bool {
        throw Exception('TODO')
    }

    private func canEncode(c: Int8): Bool {
        throw Exception('TODO')
    }

    private func inAlwaysEncodeCharsRange(c: Int8): Bool {
        throw Exception('TODO')
    }

    private func isAsciiChar(c: Int8): Bool {
        throw Exception('TODO')
    }

    public open func decode(bytes: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    private func expectedDecodingBytes(bytes: Array<Int8>): Int64 {
        throw Exception('TODO')
    }

    public open func encode(obj: Any): Any {
        throw Exception('TODO')
    }

    public open func decode(obj: Any): Any {
        throw Exception('TODO')
    }

    // Methods End
}

