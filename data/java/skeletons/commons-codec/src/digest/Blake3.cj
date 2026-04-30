// Package: commons_codec.digest
package commons_codec.digest

// Imports Begin
// Imports End

class Blake3 {
    // Fields Begin
    let engineState: Any = throw Exception('TODO')
    static let MSG_SCHEDULE: Array<Array<Int8>> = throw Exception('TODO')
    static let INT_BYTES: Int64 = throw Exception('TODO')
    static let BLOCK_LEN: Int64 = throw Exception('TODO')
    static let BLOCK_INTS: Int64 = throw Exception('TODO')
    static let KEY_LEN: Int64 = throw Exception('TODO')
    static let KEY_INTS: Int64 = throw Exception('TODO')
    static let OUT_LEN: Int64 = throw Exception('TODO')
    static let CHUNK_LEN: Int64 = throw Exception('TODO')
    static let CHAINING_VALUE_INTS: Int64 = throw Exception('TODO')
    static let IV: Array<Int64> = throw Exception('TODO')
    static let CHUNK_START: Int64 = throw Exception('TODO')
    static let CHUNK_END: Int64 = throw Exception('TODO')
    static let PARENT: Int64 = throw Exception('TODO')
    static let ROOT: Int64 = throw Exception('TODO')
    static let KEYED_HASH: Int64 = throw Exception('TODO')
    static let DERIVE_KEY_CONTEXT: Int64 = throw Exception('TODO')
    static let DERIVE_KEY_MATERIAL: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private init(key: Array<Int64>, flags: Int64) {
        throw Exception('TODO')
    }

    public func reset(): Unit {
        throw Exception('TODO')
    }

    public open func update(in: Array<Int8>): Unit {
        throw Exception('TODO')
    }

    public open func update(in: Array<Int8>, offset: Int64, length: Int64): Unit {
        throw Exception('TODO')
    }

    public open func doFinalize(out: Array<Int8>): Unit {
        throw Exception('TODO')
    }

    public open func doFinalize(out: Array<Int8>, offset: Int64, length: Int64): Unit {
        throw Exception('TODO')
    }

    public open func doFinalize(nrBytes: Int64): Array<Int8> {
        throw Exception('TODO')
    }

    public static func initHash(): Any {
        throw Exception('TODO')
    }

    public static func initKeyedHash(key: Array<Int8>): Any {
        throw Exception('TODO')
    }

    public static func initKeyDerivationFunction(kdfContext: Array<Int8>): Any {
        throw Exception('TODO')
    }

    public static func hash(data: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    public static func keyedHash(key: Array<Int8>, data: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    private static func checkBufferArgs(buffer: Array<Int8>, offset: Int64, length: Int64): Unit {
        throw Exception('TODO')
    }

    private static func packInt(value: Int64, dst: Array<Int8>, off: Int64, len: Int64): Unit {
        throw Exception('TODO')
    }

    private static func unpackInt(buf: Array<Int8>, off: Int64): Int64 {
        throw Exception('TODO')
    }

    private static func unpackInts(buf: Array<Int8>, nrInts: Int64): Array<Int64> {
        throw Exception('TODO')
    }

    private static func g(state: Array<Int64>, a: Int64, b: Int64, c: Int64, d: Int64, mx: Int64, my: Int64): Unit {
        throw Exception('TODO')
    }

    private static func round(state: Array<Int64>, msg: Array<Int64>, schedule: Array<Int8>): Unit {
        throw Exception('TODO')
    }

    private static func compress(chainingValue: Array<Int64>, blockWords: Array<Int64>, blockLength: Int64, counter: Int64, flags: Int64): Array<Int64> {
        throw Exception('TODO')
    }

    private static func parentOutput(leftChildCV: Array<Int64>, rightChildCV: Array<Int64>, key: Array<Int64>, flags: Int64): Any {
        throw Exception('TODO')
    }

    private static func parentChainingValue(leftChildCV: Array<Int64>, rightChildCV: Array<Int64>, key: Array<Int64>, flags: Int64): Array<Int64> {
        throw Exception('TODO')
    }

    // Methods End
}

open class Output {
    // Fields Begin
    let inputChainingValue: Array<Int64> = throw Exception('TODO')
    let blockWords: Array<Int64> = throw Exception('TODO')
    let counter: Int64 = throw Exception('TODO')
    let blockLength: Int64 = throw Exception('TODO')
    let flags: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    init(inputChainingValue: Array<Int64>, blockWords: Array<Int64>, counter: Int64, blockLength: Int64, flags: Int64) {
        throw Exception('TODO')
    }

    func chainingValue(): Array<Int64> {
        throw Exception('TODO')
    }

    func rootOutputBytes(out: Array<Int8>, offset: Int64, length: Int64): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

open class ChunkState {
    // Fields Begin
    var chainingValue: Array<Int64> = throw Exception('TODO')
    let chunkCounter: Int64 = throw Exception('TODO')
    let flags: Int64 = throw Exception('TODO')
    let block: Array<Int8> = throw Exception('TODO')
    var blockLength: Int64 = throw Exception('TODO')
    var blocksCompressed: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    init(key: Array<Int64>, chunkCounter: Int64, flags: Int64) {
        throw Exception('TODO')
    }

    func length(): Int64 {
        throw Exception('TODO')
    }

    func startFlag(): Int64 {
        throw Exception('TODO')
    }

    func update(input: Array<Int8>, offset: Int64, length: Int64): Unit {
        throw Exception('TODO')
    }

    func output(): Any {
        throw Exception('TODO')
    }

    // Methods End
}

open class EngineState {
    // Fields Begin
    let key: Array<Int64> = throw Exception('TODO')
    let flags: Int64 = throw Exception('TODO')
    let cvStack: Array<Array<Int64>> = throw Exception('TODO')
    var stackLen: Int64 = throw Exception('TODO')
    var state: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    init(key: Array<Int64>, flags: Int64) {
        throw Exception('TODO')
    }

    func inputData(in: Array<Int8>, offset: Int64, length: Int64): Unit {
        throw Exception('TODO')
    }

    func outputHash(out: Array<Int8>, offset: Int64, length: Int64): Unit {
        throw Exception('TODO')
    }

    func reset(): Unit {
        throw Exception('TODO')
    }

    private func addChunkCV(firstCV: Array<Int64>, totalChunks: Int64): Unit {
        throw Exception('TODO')
    }

    private func pushCV(cv: Array<Int64>): Unit {
        throw Exception('TODO')
    }

    private func popCV(): Array<Int64> {
        throw Exception('TODO')
    }

    // Methods End
}

