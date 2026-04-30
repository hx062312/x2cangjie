// Package: commons_codec.binary
package commons_codec.binary

// Imports Begin
// Imports End

open class Base32 <: BaseNCodec {
    // Fields Begin
    static let HEX_ENCODE_TABLE: Array<Int8> = throw Exception('TODO')
    static let MASK_5BITS: Int64 = throw Exception('TODO')
    static let MASK_4BITS: Int64 = throw Exception('TODO')
    static let MASK_3BITS: Int64 = throw Exception('TODO')
    static let MASK_2BITS: Int64 = throw Exception('TODO')
    static let MASK_1BITS: Int64 = throw Exception('TODO')
    let decodeSize: Int64 = throw Exception('TODO')
    let decodeTable: Array<Int8> = throw Exception('TODO')
    let encodeSize: Int64 = throw Exception('TODO')
    let encodeTable: Array<Int8> = throw Exception('TODO')
    let lineSeparator: Array<Int8> = throw Exception('TODO')
    static let BITS_PER_ENCODED_BYTE: Int64 = throw Exception('TODO')
    static let BYTES_PER_ENCODED_BLOCK: Int64 = throw Exception('TODO')
    static let BYTES_PER_UNENCODED_BLOCK: Int64 = throw Exception('TODO')
    static let DECODE_TABLE: Array<Int8> = throw Exception('TODO')
    static let ENCODE_TABLE: Array<Int8> = throw Exception('TODO')
    static let HEX_DECODE_TABLE: Array<Int8> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public init(useHex: Bool) {
        throw Exception('TODO')
    }

    public init(useHex: Bool, padding: Int8) {
        throw Exception('TODO')
    }

    public init(pad: Int8) {
        throw Exception('TODO')
    }

    public init(lineLength: Int64) {
        throw Exception('TODO')
    }

    public init(lineLength: Int64, lineSeparator: Array<Int8>) {
        throw Exception('TODO')
    }

    public init(lineLength: Int64, lineSeparator: Array<Int8>, useHex: Bool) {
        throw Exception('TODO')
    }

    public init(lineLength: Int64, lineSeparator: Array<Int8>, useHex: Bool, padding: Int8) {
        throw Exception('TODO')
    }

    public init(lineLength: Int64, lineSeparator: Array<Int8>, useHex: Bool, padding: Int8, decodingPolicy: Any) {
        throw Exception('TODO')
    }

    func decode(input: Array<Int8>, inPos: Int64, inAvail: Int64, context: Any): Unit {
        throw Exception('TODO')
    }

    func encode(input: Array<Int8>, inPos: Int64, inAvail: Int64, context: Any): Unit {
        throw Exception('TODO')
    }

    public func isInAlphabet(octet: Int8): Bool {
        throw Exception('TODO')
    }

    private func validateCharacter(emptyBitsMask: Int64, context: Any): Unit {
        throw Exception('TODO')
    }

    private func validateTrailingCharacters(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

