// Package: commons_codec.digest
package commons_codec.digest

// Imports Begin
// Imports End

class MurmurHash3 {
    // Fields Begin
    static let NULL_HASHCODE: Int64 = throw Exception('TODO')
    static let DEFAULT_SEED: Int64 = throw Exception('TODO')
    static let LONG_BYTES: Int64 = throw Exception('TODO')
    static let INTEGER_BYTES: Int64 = throw Exception('TODO')
    static let SHORT_BYTES: Int64 = throw Exception('TODO')
    static let C1_32: Int64 = throw Exception('TODO')
    static let C2_32: Int64 = throw Exception('TODO')
    static let R1_32: Int64 = throw Exception('TODO')
    static let R2_32: Int64 = throw Exception('TODO')
    static let M_32: Int64 = throw Exception('TODO')
    static let N_32: Int64 = throw Exception('TODO')
    static let C1: Int64 = throw Exception('TODO')
    static let C2: Int64 = throw Exception('TODO')
    static let R1: Int64 = throw Exception('TODO')
    static let R2: Int64 = throw Exception('TODO')
    static let R3: Int64 = throw Exception('TODO')
    static let M: Int64 = throw Exception('TODO')
    static let N1: Int64 = throw Exception('TODO')
    static let N2: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private init() {
        throw Exception('TODO')
    }

    public static func hash32(data1: Int64, data2: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash32(data1: Int64, data2: Int64, seed: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash32(data: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash32(data: Int64, seed: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash32(data: Array<Int8>): Int64 {
        throw Exception('TODO')
    }

    public static func hash32(data: String): Int64 {
        throw Exception('TODO')
    }

    public static func hash32(data: Array<Int8>, length: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash32(data: Array<Int8>, length: Int64, seed: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash32(data: Array<Int8>, offset: Int64, length: Int64, seed: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash32x86(data: Array<Int8>): Int64 {
        throw Exception('TODO')
    }

    public static func hash32x86(data: Array<Int8>, offset: Int64, length: Int64, seed: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash64(data: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash64(data: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash64(data: Int16): Int64 {
        throw Exception('TODO')
    }

    public static func hash64(data: Array<Int8>): Int64 {
        throw Exception('TODO')
    }

    public static func hash64(data: Array<Int8>, offset: Int64, length: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash64(data: Array<Int8>, offset: Int64, length: Int64, seed: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash128(data: Array<Int8>): Array<Int64> {
        throw Exception('TODO')
    }

    public static func hash128x64(data: Array<Int8>): Array<Int64> {
        throw Exception('TODO')
    }

    public static func hash128(data: String): Array<Int64> {
        throw Exception('TODO')
    }

    public static func hash128(data: Array<Int8>, offset: Int64, length: Int64, seed: Int64): Array<Int64> {
        throw Exception('TODO')
    }

    public static func hash128x64(data: Array<Int8>, offset: Int64, length: Int64, seed: Int64): Array<Int64> {
        throw Exception('TODO')
    }

    private static func hash128x64Internal(data: Array<Int8>, offset: Int64, length: Int64, seed: Int64): Array<Int64> {
        throw Exception('TODO')
    }

    private static func getLittleEndianLong(data: Array<Int8>, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private static func getLittleEndianInt(data: Array<Int8>, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private static func mix32(k: Int64, hash: Int64): Int64 {
        throw Exception('TODO')
    }

    private static func fmix32(hash: Int64): Int64 {
        throw Exception('TODO')
    }

    private static func fmix64(hash: Int64): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

open class IncrementalHash32x86 {
    // Fields Begin
    static let BLOCK_SIZE: Int64 = throw Exception('TODO')
    let unprocessed: Array<Int8> = throw Exception('TODO')
    var unprocessedLength: Int64 = throw Exception('TODO')
    var totalLen: Int64 = throw Exception('TODO')
    var hash: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public func start(seed: Int64): Unit {
        throw Exception('TODO')
    }

    public func add(data: Array<Int8>, offset: Int64, length: Int64): Unit {
        throw Exception('TODO')
    }

    public func end(): Int64 {
        throw Exception('TODO')
    }

    func finalise(hash: Int64, unprocessedLength: Int64, unprocessed: Array<Int8>, totalLen: Int64): Int64 {
        throw Exception('TODO')
    }

    private static func orBytes(b1: Int8, b2: Int8, b3: Int8, b4: Int8): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

open class IncrementalHash32 <: IncrementalHash32x86 {
    // Fields Begin
    // Fields End

    // Methods Begin
    func finalise(hash: Int64, unprocessedLength: Int64, unprocessed: Array<Int8>, totalLen: Int64): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

