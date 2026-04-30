// Package: commons_codec.binary
package commons_codec.binary

// Imports Begin
// Imports End

@Test
open class BaseNCodecTest {
    // Fields Begin
    var codec: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public func setUp(): Unit {
        throw Exception('TODO')
    }

    public func testContextToString(): Unit {
        throw Exception('TODO')
    }

    public func testBaseNCodec(): Unit {
        throw Exception('TODO')
    }

    public func testIsWhiteSpace(): Unit {
        throw Exception('TODO')
    }

    public func testIsInAlphabetByte(): Unit {
        throw Exception('TODO')
    }

    public func testIsInAlphabetByteArrayBoolean(): Unit {
        throw Exception('TODO')
    }

    public func testIsInAlphabetString(): Unit {
        throw Exception('TODO')
    }

    public func testContainsAlphabetOrPad(): Unit {
        throw Exception('TODO')
    }

    public func testProvidePaddingByte(): Unit {
        throw Exception('TODO')
    }

    public func testEnsureBufferSize(): Unit {
        throw Exception('TODO')
    }

    public func testEnsureBufferSizeExpandsToMaxBufferSize(): Unit {
        throw Exception('TODO')
    }

    public func testEnsureBufferSizeExpandsToBeyondMaxBufferSize(): Unit {
        throw Exception('TODO')
    }

    private static func assertEnsureBufferSizeExpandsToMaxBufferSize(exceedMaxBufferSize: Bool): Unit {
        throw Exception('TODO')
    }

    private static func assumeCanAllocateBufferSize(size: Int64): Unit {
        throw Exception('TODO')
    }

    static func getPresumableFreeMemory(): Int64 {
        throw Exception('TODO')
    }

    public func testEnsureBufferSizeThrowsOnOverflow(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

open class NoOpBaseNCodec <: BaseNCodec {
    // Fields Begin
    // Fields End

    // Methods Begin
    init() {
        throw Exception('TODO')
    }

    func encode(pArray: Array<Int8>, i: Int64, length: Int64, context: Any): Unit {
        throw Exception('TODO')
    }

    func decode(pArray: Array<Int8>, i: Int64, length: Int64, context: Any): Unit {
        throw Exception('TODO')
    }

    protected func isInAlphabet(value: Int8): Bool {
        throw Exception('TODO')
    }

    // Methods End
}

