// Package: commons_codec.digest
package commons_codec.digest

// Imports Begin
// Imports End

@Test
open class MurmurHash3Test {
    // Fields Begin
    static let TEST_HASH64: String = throw Exception('TODO')
    static let RANDOM_INTS: Array<Int64> = throw Exception('TODO')
    static let RANDOM_BYTES: Array<Int8> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public func testHash32LongLong(): Unit {
        throw Exception('TODO')
    }

    public func testHash32LongLongSeed(): Unit {
        throw Exception('TODO')
    }

    public func testHash32Long(): Unit {
        throw Exception('TODO')
    }

    public func testHash32LongSeed(): Unit {
        throw Exception('TODO')
    }

    private static func createLongTestData(): Array<Int64> {
        throw Exception('TODO')
    }

    public func testHash32(): Unit {
        throw Exception('TODO')
    }

    public func testHash32WithLength(): Unit {
        throw Exception('TODO')
    }

    public func testHash32WithLengthAndSeed(): Unit {
        throw Exception('TODO')
    }

    public func testHash32WithOffsetLengthAndSeed(): Unit {
        throw Exception('TODO')
    }

    private static func negativeBytes(bytes: Array<Int8>, start: Int64, length: Int64): Bool {
        throw Exception('TODO')
    }

    public func testHash32String(): Unit {
        throw Exception('TODO')
    }

    public func testHash32WithTrailingNegativeSignedBytesIsInvalid(): Unit {
        throw Exception('TODO')
    }

    public func testhash32x86(): Unit {
        throw Exception('TODO')
    }

    public func testHash32x86WithOffsetLengthAndSeed(): Unit {
        throw Exception('TODO')
    }

    public func testHash32x86WithTrailingNegativeSignedBytes(): Unit {
        throw Exception('TODO')
    }

    public func testHash64(): Unit {
        throw Exception('TODO')
    }

    public func testHash64WithOffsetAndLength(): Unit {
        throw Exception('TODO')
    }

    public func testHash64WithPrimitives(): Unit {
        throw Exception('TODO')
    }

    public func testHash64InNotEqualToHash128(): Unit {
        throw Exception('TODO')
    }

    public func testHash128(): Unit {
        throw Exception('TODO')
    }

    public func testHash128WithOffsetLengthAndSeed(): Unit {
        throw Exception('TODO')
    }

    public func testHash128WithOffsetLengthAndNegativeSeed(): Unit {
        throw Exception('TODO')
    }

    public func testHash128String(): Unit {
        throw Exception('TODO')
    }

    public func testHash128x64(): Unit {
        throw Exception('TODO')
    }

    public func testHash128x64WithOffsetLengthAndSeed(): Unit {
        throw Exception('TODO')
    }

    public func testHash128x64WithOffsetLengthAndNegativeSeed(): Unit {
        throw Exception('TODO')
    }

    public func testIncrementalHash32(): Unit {
        throw Exception('TODO')
    }

    private static func assertIncrementalHash32(bytes: Array<Int8>, seed: Int64): Unit {
        throw Exception('TODO')
    }

    public func testIncrementalHash32x86(): Unit {
        throw Exception('TODO')
    }

    private static func assertIncrementalHash32x86(bytes: Array<Int8>, seed: Int64): Unit {
        throw Exception('TODO')
    }

    private static func createRandomBlocks(maxLength: Int64): Array<Int64> {
        throw Exception('TODO')
    }

    public func testIncrementalHashWithUnprocessedBytesAndHugeLengthArray(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

