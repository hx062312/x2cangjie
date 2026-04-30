// Package: commons_codec.binary
package commons_codec.binary

// Imports Begin
// Imports End

open class BaseNTestData {
    // Fields Begin
    static let DECODED: Array<Int8> = throw Exception('TODO')
    static let SIZE_KEY: Int64 = throw Exception('TODO')
    static let LAST_READ_KEY: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    static func streamToBytes(in: InputStream): Array<Int8> {
        throw Exception('TODO')
    }

    static func streamToBytes(in: InputStream, buf: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    private static func fill(buf: Array<Int8>, offset: Int64, in: InputStream): Array<Int64> {
        throw Exception('TODO')
    }

    private static func resizeArray(bytes: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    static func randomData(codec: Any, size: Int64): Array<Array<Int8>> {
        throw Exception('TODO')
    }

    static func bytesContain(bytes: Array<Int8>, c: Int8): Bool {
        throw Exception('TODO')
    }

    // Methods End
}

