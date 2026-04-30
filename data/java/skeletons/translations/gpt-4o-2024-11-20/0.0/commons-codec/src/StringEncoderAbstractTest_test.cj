// Package: commons_codec
package commons_codec

// Imports Begin
// Imports End

@Test
abstract open class StringEncoderAbstractTest {
    // Fields Begin
    var stringEncoder: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public func checkEncoding(expected: String, source: String): Unit {
        throw Exception('TODO')
    }

    protected func checkEncodings(data: Array<Array<String>>): Unit {
        throw Exception('TODO')
    }

    protected func checkEncodingVariations(expected: String, data: String): Unit {
        throw Exception('TODO')
    }

    protected func createStringEncoder(): Any {
        throw Exception('TODO')
    }

    public func getStringEncoder(): Any {
        throw Exception('TODO')
    }

    public func testEncodeEmpty(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeNull(): Unit {
        throw Exception('TODO')
    }

    public func testEncodeWithInvalidObject(): Unit {
        throw Exception('TODO')
    }

    public func testLocaleIndependence(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

