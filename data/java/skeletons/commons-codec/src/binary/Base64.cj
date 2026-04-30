// Package: commons_codec.binary
package commons_codec.binary

// Imports Begin
// Imports End

open class Base64 <: BaseNCodec {
    // Fields Begin
    static let DECODE_TABLE: Array<Int8> = throw Exception('TODO')
    static let MASK_6BITS: Int64 = throw Exception('TODO')
    static let MASK_4BITS: Int64 = throw Exception('TODO')
    static let MASK_2BITS: Int64 = throw Exception('TODO')
    let encodeTable: Array<Int8> = throw Exception('TODO')
    let decodeTable: Array<Int8> = throw Exception('TODO')
    let lineSeparator: Array<Int8> = throw Exception('TODO')
    let decodeSize: Int64 = throw Exception('TODO')
    let encodeSize: Int64 = throw Exception('TODO')
    static let BITS_PER_ENCODED_BYTE: Int64 = throw Exception('TODO')
    static let BYTES_PER_UNENCODED_BLOCK: Int64 = throw Exception('TODO')
    static let BYTES_PER_ENCODED_BLOCK: Int64 = throw Exception('TODO')
    static let STANDARD_ENCODE_TABLE: Array<Int8> = throw Exception('TODO')
    static let URL_SAFE_ENCODE_TABLE: Array<Int8> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func decodeBase64(base64Data: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public static func decodeBase64(base64String: String): Array<Int8> {
        throw Exception('TODO')
    }

    public static func decodeInteger(pArray: Array<Int8>): BigInt {
        throw Exception('TODO')
    }

    public static func encodeBase64(binaryData: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public static func encodeBase64(binaryData: Array<Int8>, isChunked: Bool): Array<Int8> {
        throw Exception('TODO')
    }

    public static func encodeBase64(binaryData: Array<Int8>, isChunked: Bool, urlSafe: Bool): Array<Int8> {
        throw Exception('TODO')
    }

    public static func encodeBase64(binaryData: Array<Int8>, isChunked: Bool, urlSafe: Bool, maxResultSize: Int64): Array<Int8> {
        throw Exception('TODO')
    }

    public static func encodeBase64Chunked(binaryData: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public static func encodeBase64String(binaryData: Array<Int8>): String {
        throw Exception('TODO')
    }

    public static func encodeBase64URLSafe(binaryData: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public static func encodeBase64URLSafeString(binaryData: Array<Int8>): String {
        throw Exception('TODO')
    }

    public static func encodeInteger(bigInteger: BigInt): Array<Int8> {
        throw Exception('TODO')
    }

    public static func isArrayByteBase64(arrayOctet: Array<Int8>): Bool {
        throw Exception('TODO')
    }

    public static func isBase64(octet: Int8): Bool {
        throw Exception('TODO')
    }

    public static func isBase64(arrayOctet: Array<Int8>): Bool {
        throw Exception('TODO')
    }

    public static func isBase64(base64: String): Bool {
        throw Exception('TODO')
    }

    static func toIntegerBytes(bigInt: BigInt): Array<Int8> {
        throw Exception('TODO')
    }

    public init() {
        throw Exception('TODO')
    }

    public init(urlSafe: Bool) {
        throw Exception('TODO')
    }

    public init(lineLength: Int64) {
        throw Exception('TODO')
    }

    public init(lineLength: Int64, lineSeparator: Array<Int8>) {
        throw Exception('TODO')
    }

    public init(lineLength: Int64, lineSeparator: Array<Int8>, urlSafe: Bool) {
        throw Exception('TODO')
    }

    public init(lineLength: Int64, lineSeparator: Array<Int8>, urlSafe: Bool, decodingPolicy: Any) {
        throw Exception('TODO')
    }

    func decode(in: Array<Int8>, inPos: Int64, inAvail: Int64, context: Any): Unit {
        throw Exception('TODO')
    }

    func encode(in: Array<Int8>, inPos: Int64, inAvail: Int64, context: Any): Unit {
        throw Exception('TODO')
    }

    protected func isInAlphabet(octet: Int8): Bool {
        throw Exception('TODO')
    }

    public func isUrlSafe(): Bool {
        throw Exception('TODO')
    }

    private func validateCharacter(emptyBitsMask: Int64, context: Any): Unit {
        throw Exception('TODO')
    }

    private func validateTrailingCharacter(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

