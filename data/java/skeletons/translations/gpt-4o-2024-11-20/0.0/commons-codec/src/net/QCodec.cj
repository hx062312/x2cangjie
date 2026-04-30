// Package: commons_codec.net
package commons_codec.net

// Imports Begin
// Imports End

open class QCodec <: RFC1522Codec {
    // Fields Begin
    static let SPACE: Int8 = throw Exception('TODO')
    static let UNDERSCORE: Int8 = throw Exception('TODO')
    var encodeBlanks: Bool = throw Exception('TODO')
    let charset: Any = throw Exception('TODO')
    static let PRINTABLE_CHARS: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public init(charset: Any) {
        throw Exception('TODO')
    }

    public init(charsetName: String) {
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

    public open func encode(sourceStr: String, sourceCharset: Any): String {
        throw Exception('TODO')
    }

    public open func encode(sourceStr: String, sourceCharset: String): String {
        throw Exception('TODO')
    }

    public open func encode(sourceStr: String): String {
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

    public func getCharset(): Any {
        throw Exception('TODO')
    }

    public func getDefaultCharset(): String {
        throw Exception('TODO')
    }

    public func isEncodeBlanks(): Bool {
        throw Exception('TODO')
    }

    public func setEncodeBlanks(b: Bool): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

