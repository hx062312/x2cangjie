// Package: commons_codec.net
package commons_codec.net

// Imports Begin
// Imports End

abstract open class RFC1522Codec {
    // Fields Begin
    static let SEP: Rune = throw Exception('TODO')
    static let POSTFIX: String = throw Exception('TODO')
    static let PREFIX: String = throw Exception('TODO')
    // Fields End

    // Methods Begin
    protected open func encodeText(text: String, charset: Any): String {
        throw Exception('TODO')
    }

    protected open func encodeText(text: String, charsetName: String): String {
        throw Exception('TODO')
    }

    protected func decodeText(text: String): String {
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

    // Methods End
}

