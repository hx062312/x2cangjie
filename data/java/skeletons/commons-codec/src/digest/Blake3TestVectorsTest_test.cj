// Package: commons_codec.digest
package commons_codec.digest

// Imports Begin
// Imports End

@Test
open class Blake3TestVectorsTest {
    // Fields Begin
    let hasher: Any = throw Exception('TODO')
    let keyedHasher: Any = throw Exception('TODO')
    let kdfHasher: Any = throw Exception('TODO')
    let input: Array<Int8> = throw Exception('TODO')
    let hash: Array<Int8> = throw Exception('TODO')
    let keyedHash: Array<Int8> = throw Exception('TODO')
    let deriveKey: Array<Int8> = throw Exception('TODO')
    static let KEY: Array<Int8> = throw Exception('TODO')
    static let CTX: Array<Int8> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func testCases(): Array<Array<Any>> {
        throw Exception('TODO')
    }

    public init(inputLength: Int64, hash: String, keyedHash: String, deriveKey: String) {
        throw Exception('TODO')
    }

    public func hashArbitraryOutputLength(): Unit {
        throw Exception('TODO')
    }

    public func hashTruncatedOutput(): Unit {
        throw Exception('TODO')
    }

    public func keyedHashArbitraryOutputLength(): Unit {
        throw Exception('TODO')
    }

    public func keyedHashTruncatedOutput(): Unit {
        throw Exception('TODO')
    }

    public func keyDerivation(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

