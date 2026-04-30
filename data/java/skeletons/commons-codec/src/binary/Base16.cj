// Package: commons_codec.binary
package commons_codec.binary

// Imports Begin
// Imports End

open class Base16 <: BaseNCodec {
    // Fields Begin
    static let MASK_4BITS: Int64 = throw Exception('TODO')
    let decodeTable: Array<Int8> = throw Exception('TODO')
    let encodeTable: Array<Int8> = throw Exception('TODO')
    static let BITS_PER_ENCODED_BYTE: Int64 = throw Exception('TODO')
    static let BYTES_PER_ENCODED_BLOCK: Int64 = throw Exception('TODO')
    static let BYTES_PER_UNENCODED_BLOCK: Int64 = throw Exception('TODO')
    static let UPPER_CASE_DECODE_TABLE: Array<Int8> = throw Exception('TODO')
    static let UPPER_CASE_ENCODE_TABLE: Array<Int8> = throw Exception('TODO')
    static let LOWER_CASE_DECODE_TABLE: Array<Int8> = throw Exception('TODO')
    static let LOWER_CASE_ENCODE_TABLE: Array<Int8> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public init(lowerCase: Bool) {
        throw Exception('TODO')
    }

    public init(lowerCase: Bool, decodingPolicy: Any) {
        throw Exception('TODO')
    }

    func decode(data: Array<Int8>, offset: Int64, length: Int64, context: Any): Unit {
        throw Exception('TODO')
    }

    private func decodeOctet(octet: Int8): Int64 {
        throw Exception('TODO')
    }

    func encode(data: Array<Int8>, offset: Int64, length: Int64, context: Any): Unit {
        throw Exception('TODO')
    }

    public func isInAlphabet(octet: Int8): Bool {
        throw Exception('TODO')
    }

    private func validateTrailingCharacter(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

