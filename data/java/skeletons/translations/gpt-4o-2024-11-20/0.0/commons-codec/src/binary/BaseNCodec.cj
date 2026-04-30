// Package: commons_codec.binary
package commons_codec.binary

// Imports Begin
// Imports End

abstract open class BaseNCodec <: BinaryEncoder & BinaryDecoder {
    // Fields Begin
    static let EOF: Int64 = throw Exception('TODO')
    static let MIME_CHUNK_SIZE: Int64 = throw Exception('TODO')
    static let PEM_CHUNK_SIZE: Int64 = throw Exception('TODO')
    static let DEFAULT_BUFFER_RESIZE_FACTOR: Int64 = throw Exception('TODO')
    static let DEFAULT_BUFFER_SIZE: Int64 = throw Exception('TODO')
    static let MAX_BUFFER_SIZE: Int64 = throw Exception('TODO')
    static let MASK_8BITS: Int64 = throw Exception('TODO')
    static let PAD_DEFAULT: Int8 = throw Exception('TODO')
    static let DECODING_POLICY_DEFAULT: Any = throw Exception('TODO')
    static let CHUNK_SEPARATOR: Array<Int8> = throw Exception('TODO')
    let PAD: Int8 = throw Exception('TODO')
    let pad: Int8 = throw Exception('TODO')
    let unencodedBlockSize: Int64 = throw Exception('TODO')
    let encodedBlockSize: Int64 = throw Exception('TODO')
    let lineLength: Int64 = throw Exception('TODO')
    let chunkSeparatorLength: Int64 = throw Exception('TODO')
    let decodingPolicy: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private static func compareUnsigned(x: Int64, y: Int64): Int64 {
        throw Exception('TODO')
    }

    private static func createPositiveCapacity(minCapacity: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func getChunkSeparator(): Array<Int8> {
        throw Exception('TODO')
    }

    protected static func isWhiteSpace(byteToCheck: Int8): Bool {
        throw Exception('TODO')
    }

    private static func resizeBuffer(context: Any, minCapacity: Int64): Array<Int8> {
        throw Exception('TODO')
    }

    protected init(unencodedBlockSize: Int64, encodedBlockSize: Int64, lineLength: Int64, chunkSeparatorLength: Int64) {
        throw Exception('TODO')
    }

    protected init(unencodedBlockSize: Int64, encodedBlockSize: Int64, lineLength: Int64, chunkSeparatorLength: Int64, pad: Int8) {
        throw Exception('TODO')
    }

    protected init(unencodedBlockSize: Int64, encodedBlockSize: Int64, lineLength: Int64, chunkSeparatorLength: Int64, pad: Int8, decodingPolicy: Any) {
        throw Exception('TODO')
    }

    func available(context: Any): Int64 {
        throw Exception('TODO')
    }

    protected func containsAlphabetOrPad(arrayOctet: Array<Int8>): Bool {
        throw Exception('TODO')
    }

    public open func decode(pArray: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    open func decode(pArray: Array<Int8>, i: Int64, length: Int64, context: Any): Unit {
        throw Exception('TODO')
    }

    public open func decode(obj: Any): Any {
        throw Exception('TODO')
    }

    public open func decode(pArray: String): Array<Int8> {
        throw Exception('TODO')
    }

    public open func encode(pArray: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public open func encode(pArray: Array<Int8>, offset: Int64, length: Int64): Array<Int8> {
        throw Exception('TODO')
    }

    open func encode(pArray: Array<Int8>, i: Int64, length: Int64, context: Any): Unit {
        throw Exception('TODO')
    }

    public open func encode(obj: Any): Any {
        throw Exception('TODO')
    }

    public func encodeAsString(pArray: Array<Int8>): String {
        throw Exception('TODO')
    }

    public func encodeToString(pArray: Array<Int8>): String {
        throw Exception('TODO')
    }

    protected func ensureBufferSize(size: Int64, context: Any): Array<Int8> {
        throw Exception('TODO')
    }

    public func getCodecPolicy(): Any {
        throw Exception('TODO')
    }

    protected func getDefaultBufferSize(): Int64 {
        throw Exception('TODO')
    }

    public func getEncodedLength(pArray: Array<Int8>): Int64 {
        throw Exception('TODO')
    }

    func hasData(context: Any): Bool {
        throw Exception('TODO')
    }

    protected open func isInAlphabet(value: Int8): Bool {
        throw Exception('TODO')
    }

    public open func isInAlphabet(arrayOctet: Array<Int8>, allowWSPad: Bool): Bool {
        throw Exception('TODO')
    }

    public open func isInAlphabet(basen: String): Bool {
        throw Exception('TODO')
    }

    public func isStrictDecoding(): Bool {
        throw Exception('TODO')
    }

    func readResults(b: Array<Int8>, bPos: Int64, bAvail: Int64, context: Any): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

open class Context {
    // Fields Begin
    var modulus: Int64 = throw Exception('TODO')
    var ibitWorkArea: Int64 = throw Exception('TODO')
    var lbitWorkArea: Int64 = throw Exception('TODO')
    var buffer: Array<Int8> = throw Exception('TODO')
    var pos: Int64 = throw Exception('TODO')
    var readPos: Int64 = throw Exception('TODO')
    var eof: Bool = throw Exception('TODO')
    var currentLinePos: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    init() {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

