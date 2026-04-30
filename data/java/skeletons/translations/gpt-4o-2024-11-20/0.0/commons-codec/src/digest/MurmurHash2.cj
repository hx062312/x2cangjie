// Package: commons_codec.digest
package commons_codec.digest

// Imports Begin
// Imports End

class MurmurHash2 {
    // Fields Begin
    static let M32: Int64 = throw Exception('TODO')
    static let R32: Int64 = throw Exception('TODO')
    static let M64: Int64 = throw Exception('TODO')
    static let R64: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private init() {
        throw Exception('TODO')
    }

    public static func hash32(data: Array<Int8>, length: Int64, seed: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash32(data: Array<Int8>, length: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash32(text: String): Int64 {
        throw Exception('TODO')
    }

    public static func hash32(text: String, from: Int64, length: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash64(data: Array<Int8>, length: Int64, seed: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash64(data: Array<Int8>, length: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func hash64(text: String): Int64 {
        throw Exception('TODO')
    }

    public static func hash64(text: String, from: Int64, length: Int64): Int64 {
        throw Exception('TODO')
    }

    private static func getLittleEndianInt(data: Array<Int8>, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private static func getLittleEndianLong(data: Array<Int8>, index: Int64): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

