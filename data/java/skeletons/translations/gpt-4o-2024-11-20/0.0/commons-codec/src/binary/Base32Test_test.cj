// Package: commons_codec.binary
package commons_codec.binary

// Imports Begin
// Imports End

@Test
open class Base32Test {
    // Fields Begin
    static let BASE32HEX_TEST_CASES: Array<Array<String>> = throw Exception('TODO')
    static let BASE32_TEST_CASES_CHUNKED: Array<Array<String>> = throw Exception('TODO')
    static let BASE32_PAD_TEST_CASES: Array<Array<String>> = throw Exception('TODO')
    static let CHARSET_UTF8: Any = throw Exception('TODO')
    static let BASE32_TEST_CASES: Array<Array<String>> = throw Exception('TODO')
    static let BASE32_IMPOSSIBLE_CASES: Array<String> = throw Exception('TODO')
    static let BASE32_IMPOSSIBLE_CASES_CHUNKED: Array<String> = throw Exception('TODO')
    static let BASE32HEX_IMPOSSIBLE_CASES: Array<String> = throw Exception('TODO')
    static let ENCODE_TABLE: Array<Int8> = throw Exception('TODO')
    static let BASE32_BINARY_TEST_CASES: Array<Array<Any>> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public func testBase32Chunked(): Unit {
        throw Exception('TODO')
    }

    public func testBase32HexSamples(): Unit {
        throw Exception('TODO')
    }

    public func testBase32HexSamplesReverse(): Unit {
        throw Exception('TODO')
    }

    public func testBase32HexSamplesReverseLowercase(): Unit {
        throw Exception('TODO')
    }

    public func testBase32Samples(): Unit {
        throw Exception('TODO')
    }

    public func testBase32BinarySamples(): Unit {
        throw Exception('TODO')
    }

    public func testBase32BinarySamplesReverse(): Unit {
        throw Exception('TODO')
    }

    public func testBase32SamplesNonDefaultPadding(): Unit {
        throw Exception('TODO')
    }

    public func testCodec200(): Unit {
        throw Exception('TODO')
    }

    public func testConstructors(): Unit {
        throw Exception('TODO')
    }

    public func testEmptyBase32(): Unit {
        throw Exception('TODO')
    }

    public func testIsInAlphabet(): Unit {
        throw Exception('TODO')
    }

    public func testRandomBytes(): Unit {
        throw Exception('TODO')
    }

    public func testRandomBytesChunked(): Unit {
        throw Exception('TODO')
    }

    public func testRandomBytesHex(): Unit {
        throw Exception('TODO')
    }

    public func testSingleCharEncoding(): Unit {
        throw Exception('TODO')
    }

    public func testBase32ImpossibleSamples(): Unit {
        throw Exception('TODO')
    }

    public func testBase32ImpossibleChunked(): Unit {
        throw Exception('TODO')
    }

    public func testBase32HexImpossibleSamples(): Unit {
        throw Exception('TODO')
    }

    private func testImpossibleCases(codec: Any, impossible_cases: Array<String>): Unit {
        throw Exception('TODO')
    }

    public func testBase32DecodingOfTrailing5Bits(): Unit {
        throw Exception('TODO')
    }

    public func testBase32DecodingOfTrailing10Bits(): Unit {
        throw Exception('TODO')
    }

    public func testBase32DecodingOfTrailing15Bits(): Unit {
        throw Exception('TODO')
    }

    public func testBase32DecodingOfTrailing20Bits(): Unit {
        throw Exception('TODO')
    }

    public func testBase32DecodingOfTrailing25Bits(): Unit {
        throw Exception('TODO')
    }

    public func testBase32DecodingOfTrailing30Bits(): Unit {
        throw Exception('TODO')
    }

    public func testBase32DecodingOfTrailing35Bits(): Unit {
        throw Exception('TODO')
    }

    private static func assertBase32DecodingOfTrailingBits(nbits: Int64): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

