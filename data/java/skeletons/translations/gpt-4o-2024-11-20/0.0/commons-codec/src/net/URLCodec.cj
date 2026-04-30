// Package: commons_codec.net
package commons_codec.net

// Imports Begin
// Imports End

open class URLCodec <: BinaryEncoder & BinaryDecoder & StringEncoder & StringDecoder {
    // Fields Begin
    var charset: String = throw Exception('TODO')
    static let ESCAPE_CHAR: Int8 = throw Exception('TODO')
    static let WWW_FORM_URL: Any = throw Exception('TODO')
    static let WWW_FORM_URL_SAFE: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public init(charset: String) {
        throw Exception('TODO')
    }

    public static func encodeUrl(urlsafe: Any, bytes: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public static func decodeUrl(bytes: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public open func encode(bytes: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public open func decode(bytes: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public open func encode(str: String, charsetName: String): String {
        throw Exception('TODO')
    }

    public open func encode(str: String): String {
        throw Exception('TODO')
    }

    public open func decode(str: String, charsetName: String): String {
        throw Exception('TODO')
    }

    public open func decode(str: String): String {
        throw Exception('TODO')
    }

    public open func encode(obj: Any): Any {
        throw Exception('TODO')
    }

    public open func decode(obj: Any): Any {
        throw Exception('TODO')
    }

    public func getDefaultCharset(): String {
        throw Exception('TODO')
    }

    public func getEncoding(): String {
        throw Exception('TODO')
    }

    // Methods End
}

