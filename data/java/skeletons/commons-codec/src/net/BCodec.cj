// Package: commons_codec.net
package commons_codec.net

// Imports Begin
// Imports End

open class BCodec <: RFC1522Codec {
    // Fields Begin
    static let DECODING_POLICY_DEFAULT: Any = throw Exception('TODO')
    let charset: Any = throw Exception('TODO')
    let decodingPolicy: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public init(charset: Any) {
        throw Exception('TODO')
    }

    public init(charset: Any, decodingPolicy: Any) {
        throw Exception('TODO')
    }

    public init(charsetName: String) {
        throw Exception('TODO')
    }

    public func isStrictDecoding(): Bool {
        throw Exception('TODO')
    }

    protected func getEncoding(): String {
        throw Exception('TODO')
    }

    protected func doEncoding(bytes: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    protected func doDecoding(bytes: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public open func encode(strSource: String, sourceCharset: Any): String {
        throw Exception('TODO')
    }

    public open func encode(strSource: String, sourceCharset: String): String {
        throw Exception('TODO')
    }

    public open func encode(strSource: String): String {
        throw Exception('TODO')
    }

    public open func decode(value: String): String {
        throw Exception('TODO')
    }

    public open func encode(value: Any): Any {
        throw Exception('TODO')
    }

    public open func decode(value: Any): Any {
        throw Exception('TODO')
    }

    public func getCharset(): Any {
        throw Exception('TODO')
    }

    public func getDefaultCharset(): String {
        throw Exception('TODO')
    }

    // Methods End
}

