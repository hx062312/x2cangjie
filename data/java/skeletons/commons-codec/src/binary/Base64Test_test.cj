// Package: commons_codec.binary
package commons_codec.binary

// Imports Begin
// Imports End

@Test
open class Base64Test {
    // Fields Begin
    static let CHARSET_UTF8: Any = throw Exception('TODO')
    static let BASE64_IMPOSSIBLE_CASES: Array<String> = throw Exception('TODO')
    static let STANDARD_ENCODE_TABLE: Array<Int8> = throw Exception('TODO')
    let random: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public func getRandom(): Any {
        throw Exception('TODO')
    }

    public func testIsStringBase64(): Unit {
        throw Exception('TODO')
    }

    public func testBase64(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeWithInnerPad(): Unit {
        throw Exception('TODO')
    }

    public func testChunkedEncodeMultipleOf76(): Unit {
        throw Exception('TODO')
    }

    public func testCodec68(): Unit {
        throw Exception('TODO')
    }

    public func testCodeInteger1(): Unit {
        throw Exception('TODO')
    }

    public func testCodeInteger2(): Unit {
        throw Exception('TODO')
    }

    public func testCodeInteger3(): Unit {
        throw Exception('TODO')
    }

    public func testCodeInteger4(): Unit {
        throw Exception('TODO')
    }

    public func testCodeIntegerEdgeCases(): Unit {
        throw Exception('TODO')
    }

    public func testCodeIntegerNull(): Unit {
        throw Exception('TODO')
    }

    public func testConstructors(): Unit {
        throw Exception('TODO')
    }

    public func testConstructor_Int_ByteArray_Boolean(): Unit {
        throw Exception('TODO')
    }

    public func testConstructor_Int_ByteArray_Boolean_UrlSafe(): Unit {
        throw Exception('TODO')
    }

    public func testDecodePadMarkerIndex2(): Unit {
        throw Exception('TODO')
    }

    public func testDecodePadMarkerIndex3(): Unit {
        throw Exception('TODO')
    }

    public func testDecodePadOnly(): Unit {
        throw Exception('TODO')
    }

    public func testDecodePadOnlyChunked(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeWithWhitespace(): Unit {
        throw Exception('TODO')
    }

    public func testEmptyBase64(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeDecodeRandom(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeDecodeSmall(): Unit {
        throw Exception('TODO')
    }

    public open func testEncodeOverMaxSize(): Unit {
        throw Exception('TODO')
    }

    public func testCodec112(): Unit {
        throw Exception('TODO')
    }

    private open func testEncodeOverMaxSize(maxSize: Int64): Unit {
        throw Exception('TODO')
    }

    public func testIgnoringNonBase64InDecode(): Unit {
        throw Exception('TODO')
    }

    public func testIsArrayByteBase64(): Unit {
        throw Exception('TODO')
    }

    public func testIsUrlSafe(): Unit {
        throw Exception('TODO')
    }

    public func testKnownDecodings(): Unit {
        throw Exception('TODO')
    }

    public func testKnownEncodings(): Unit {
        throw Exception('TODO')
    }

    public func testNonBase64Test(): Unit {
        throw Exception('TODO')
    }

    public func testObjectDecodeWithInvalidParameter(): Unit {
        throw Exception('TODO')
    }

    public func testObjectDecodeWithValidParameter(): Unit {
        throw Exception('TODO')
    }

    public func testObjectEncodeWithInvalidParameter(): Unit {
        throw Exception('TODO')
    }

    public func testObjectEncodeWithValidParameter(): Unit {
        throw Exception('TODO')
    }

    public func testObjectEncode(): Unit {
        throw Exception('TODO')
    }

    public func testPairs(): Unit {
        throw Exception('TODO')
    }

    public func testRfc2045Section2Dot1CrLfDefinition(): Unit {
        throw Exception('TODO')
    }

    public func testRfc2045Section6Dot8ChunkSizeDefinition(): Unit {
        throw Exception('TODO')
    }

    public func testRfc1421Section6Dot8ChunkSizeDefinition(): Unit {
        throw Exception('TODO')
    }

    public func testRfc4648Section10Decode(): Unit {
        throw Exception('TODO')
    }

    public func testRfc4648Section10DecodeWithCrLf(): Unit {
        throw Exception('TODO')
    }

    public func testRfc4648Section10Encode(): Unit {
        throw Exception('TODO')
    }

    public func testRfc4648Section10DecodeEncode(): Unit {
        throw Exception('TODO')
    }

    private func testDecodeEncode(encodedText: String): Unit {
        throw Exception('TODO')
    }

    public func testRfc4648Section10EncodeDecode(): Unit {
        throw Exception('TODO')
    }

    private func testEncodeDecode(plainText: String): Unit {
        throw Exception('TODO')
    }

    public func testSingletons(): Unit {
        throw Exception('TODO')
    }

    public func testSingletonsChunked(): Unit {
        throw Exception('TODO')
    }

    public func testTriplets(): Unit {
        throw Exception('TODO')
    }

    public func testTripletsChunked(): Unit {
        throw Exception('TODO')
    }

    public func testUrlSafe(): Unit {
        throw Exception('TODO')
    }

    public func testUUID(): Unit {
        throw Exception('TODO')
    }

    public func testByteToStringVariations(): Unit {
        throw Exception('TODO')
    }

    public func testStringToByteVariations(): Unit {
        throw Exception('TODO')
    }

    private func toString(data: Array<Int8>): String {
        throw Exception('TODO')
    }

    public func testHugeLineSeparator(): Unit {
        throw Exception('TODO')
    }

    public func testBase64ImpossibleSamples(): Unit {
        throw Exception('TODO')
    }

    public func testBase64DecodingOfTrailing6Bits(): Unit {
        throw Exception('TODO')
    }

    public func testBase64DecodingOfTrailing12Bits(): Unit {
        throw Exception('TODO')
    }

    public func testBase64DecodingOfTrailing18Bits(): Unit {
        throw Exception('TODO')
    }

    private static func assertBase64DecodingOfTrailingBits(nbits: Int64): Unit {
        throw Exception('TODO')
    }

    public func testCodec265(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

