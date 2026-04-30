// Package: commons_codec.binary
package commons_codec.binary

// Imports Begin
// Imports End

@Test
open class HexTest {
    // Fields Begin
    static let BAD_ENCODING_NAME: String = throw Exception('TODO')
    static let LOG: Bool = throw Exception('TODO')
    // Fields End

    // Methods Begin
    protected func allocate(capacity: Int64): ByteBuffer {
        throw Exception('TODO')
    }

    private func getByteBufferUtf8(string: String): ByteBuffer {
        throw Exception('TODO')
    }

    private func charsetSanityCheck(name: String): Bool {
        throw Exception('TODO')
    }

    private open func checkDecodeHexCharArrayOddCharacters(data: Array<Rune>): Unit {
        throw Exception('TODO')
    }

    private func checkDecodeHexByteBufferOddCharacters(data: ByteBuffer): Unit {
        throw Exception('TODO')
    }

    private open func checkDecodeHexCharArrayOddCharacters(data: String): Unit {
        throw Exception('TODO')
    }

    private open func log(s: String): Unit {
        throw Exception('TODO')
    }

    private open func log(t: Any): Unit {
        throw Exception('TODO')
    }

    public open func testCustomCharset(): Unit {
        throw Exception('TODO')
    }

    private open func testCustomCharset(name: String, parent: String): Unit {
        throw Exception('TODO')
    }

    public func testCustomCharsetBadName(): Unit {
        throw Exception('TODO')
    }

    public func testCustomCharsetToString(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeBadCharacterPos0(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeBadCharacterPos1(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeByteArrayEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeByteArrayObjectEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeByteArrayOddCharacters(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeByteBufferEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeByteBufferAllocatedButEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeByteBufferObjectEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeByteBufferOddCharacters(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeByteBufferWithLimitOddCharacters(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeHexCharArrayEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeHexStringEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeClassCastException(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeHexCharArrayOddCharacters1(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeHexStringOddCharacters1(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeHexCharArrayOddCharacters3(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeHexCharArrayOddCharacters5(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeHexCharArrayOutBufferUnderSized(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeHexCharArrayOutBufferUnderSizedByOffset(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeHexStringOddCharacters(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeStringEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testDecodeByteBufferWithLimit(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeByteArrayEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeByteArrayObjectEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeByteBufferEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeByteBufferAllocatedButEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeByteBufferObjectEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeClassCastException(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeDecodeHexCharArrayRandom(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeDecodeHexCharArrayRandomToOutput(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteArrayEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteArrayHelloWorldLowerCaseHex(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteArrayHelloWorldUpperCaseHex(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteArrayZeroes(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteBufferEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteBufferHelloWorldLowerCaseHex(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteBufferHelloWorldUpperCaseHex(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHex_ByteBufferOfZeroes(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHex_ByteBufferWithLimit(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexPartialInput(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexPartialInputUnderbounds(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexPartialInputOverbounds(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteString_ByteBufferOfZeroes(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteString_ByteBufferOfZeroesWithLimit(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteString_ByteArrayOfZeroes(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteString_ByteArrayBoolean_ToLowerCase(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteString_ByteArrayBoolean_ToUpperCase(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteString_ByteBufferBoolean_ToLowerCase(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteString_ByteBufferBoolean_ToUpperCase(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteString_ByteBufferWithLimitBoolean_ToLowerCase(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexByteString_ByteBufferWithLimitBoolean_ToUpperCase(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeHexReadOnlyByteBuffer(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeStringEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testGetCharset(): Unit {
        throw Exception('TODO')
    }

    public func testGetCharsetName(): Unit {
        throw Exception('TODO')
    }

    public func testRequiredCharset(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

