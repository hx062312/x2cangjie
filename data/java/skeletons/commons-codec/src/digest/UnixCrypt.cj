// Package: commons_codec.digest
package commons_codec.digest

// Imports Begin
// Imports End

open class UnixCrypt {
    // Fields Begin
    static let SPTRANS: Int64 = throw Exception('TODO')
    static let CON_SALT: Int64 = throw Exception('TODO')
    static let COV2CHAR: Int64 = throw Exception('TODO')
    static let SALT_CHARS: Rune = throw Exception('TODO')
    static let SHIFT2: Bool = throw Exception('TODO')
    static let SKB: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func crypt(original: Array<Int8>): String {
        throw Exception('TODO')
    }

    public static func crypt(original: Array<Int8>, salt: String): String {
        throw Exception('TODO')
    }

    public static func crypt(original: String): String {
        throw Exception('TODO')
    }

    public static func crypt(original: String, salt: String): String {
        throw Exception('TODO')
    }

    private static func body(schedule: Int64, eSwap0: Int64, eSwap1: Int64): Array<Int64> {
        throw Exception('TODO')
    }

    private static func byteToUnsigned(b: Int8): Int64 {
        throw Exception('TODO')
    }

    private static func dEncrypt(el: Int64, r: Int64, s: Int64, e0: Int64, e1: Int64, sArr: Int64): Int64 {
        throw Exception('TODO')
    }

    private static func desSetKey(key: Int8): Array<Int64> {
        throw Exception('TODO')
    }

    private static func fourBytesToInt(b: Int8, offset: Int64): Int64 {
        throw Exception('TODO')
    }

    private static func hPermOp(a: Int64, n: Int64, m: Int64): Int64 {
        throw Exception('TODO')
    }

    private static func intToFourBytes(iValue: Int64, b: Int8, offset: Int64): Unit {
        throw Exception('TODO')
    }

    private static func permOp(a: Int64, b: Int64, n: Int64, m: Int64, results: Int64): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

