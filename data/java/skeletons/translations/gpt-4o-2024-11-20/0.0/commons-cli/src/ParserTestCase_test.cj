// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

@Test
abstract class ParserTestCase {
    // Fields Begin
    var parser: Any = throw Exception('TODO')
    var options: Options = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private func parse(parser: Any, opts: Options, args: Array<String>, properties: HashMap<String, String>): Any {
        throw Exception('TODO')
    }

    public func setUp(): Unit {
        throw Exception('TODO')
    }

    public func testAmbiguousLongWithoutEqualSingleDash(): Unit {
        throw Exception('TODO')
    }

    public func testAmbiguousPartialLongOption1(): Unit {
        throw Exception('TODO')
    }

    public func testAmbiguousPartialLongOption2(): Unit {
        throw Exception('TODO')
    }

    public func testAmbiguousPartialLongOption3(): Unit {
        throw Exception('TODO')
    }

    public func testAmbiguousPartialLongOption4(): Unit {
        throw Exception('TODO')
    }

    public func testArgumentStartingWithHyphen(): Unit {
        throw Exception('TODO')
    }

    public func testBursting(): Unit {
        throw Exception('TODO')
    }

    public func testDoubleDash1(): Unit {
        throw Exception('TODO')
    }

    public func testDoubleDash2(): Unit {
        throw Exception('TODO')
    }

    public func testLongOptionQuoteHandling(): Unit {
        throw Exception('TODO')
    }

    public func testLongOptionWithEqualsQuoteHandling(): Unit {
        throw Exception('TODO')
    }

    public func testLongWithEqualDoubleDash(): Unit {
        throw Exception('TODO')
    }

    public func testLongWithEqualSingleDash(): Unit {
        throw Exception('TODO')
    }

    public func testLongWithoutEqualDoubleDash(): Unit {
        throw Exception('TODO')
    }

    public func testLongWithoutEqualSingleDash(): Unit {
        throw Exception('TODO')
    }

    public func testLongWithUnexpectedArgument1(): Unit {
        throw Exception('TODO')
    }

    public func testLongWithUnexpectedArgument2(): Unit {
        throw Exception('TODO')
    }

    public func testMissingArg(): Unit {
        throw Exception('TODO')
    }

    public func testMissingArgWithBursting(): Unit {
        throw Exception('TODO')
    }

    public func testMissingRequiredGroup(): Unit {
        throw Exception('TODO')
    }

    public func testMissingRequiredOption(): Unit {
        throw Exception('TODO')
    }

    public func testMissingRequiredOptions(): Unit {
        throw Exception('TODO')
    }

    public func testMultiple(): Unit {
        throw Exception('TODO')
    }

    public func testMultipleWithLong(): Unit {
        throw Exception('TODO')
    }

    public func testNegativeArgument(): Unit {
        throw Exception('TODO')
    }

    public func testNegativeOption(): Unit {
        throw Exception('TODO')
    }

    public func testOptionAndRequiredOption(): Unit {
        throw Exception('TODO')
    }

    public func testOptionGroup(): Unit {
        throw Exception('TODO')
    }

    public func testOptionGroupLong(): Unit {
        throw Exception('TODO')
    }

    public func testPartialLongOptionSingleDash(): Unit {
        throw Exception('TODO')
    }

    public func testPropertiesOption1(): Unit {
        throw Exception('TODO')
    }

    public func testPropertiesOption2(): Unit {
        throw Exception('TODO')
    }

    public func testPropertyOptionFlags(): Unit {
        throw Exception('TODO')
    }

    public func testPropertyOptionGroup(): Unit {
        throw Exception('TODO')
    }

    public func testPropertyOptionMultipleValues(): Unit {
        throw Exception('TODO')
    }

    public func testPropertyOptionRequired(): Unit {
        throw Exception('TODO')
    }

    public func testPropertyOptionSingularValue(): Unit {
        throw Exception('TODO')
    }

    public func testPropertyOptionUnexpected(): Unit {
        throw Exception('TODO')
    }

    public func testPropertyOverrideValues(): Unit {
        throw Exception('TODO')
    }

    public func testReuseOptionsTwice(): Unit {
        throw Exception('TODO')
    }

    public func testShortOptionConcatenatedQuoteHandling(): Unit {
        throw Exception('TODO')
    }

    public func testShortOptionQuoteHandling(): Unit {
        throw Exception('TODO')
    }

    public func testShortWithEqual(): Unit {
        throw Exception('TODO')
    }

    public func testShortWithoutEqual(): Unit {
        throw Exception('TODO')
    }

    public func testShortWithUnexpectedArgument(): Unit {
        throw Exception('TODO')
    }

    public func testSimpleLong(): Unit {
        throw Exception('TODO')
    }

    public func testSimpleShort(): Unit {
        throw Exception('TODO')
    }

    public func testSingleDash(): Unit {
        throw Exception('TODO')
    }

    public func testStopAtExpectedArg(): Unit {
        throw Exception('TODO')
    }

    public func testStopAtNonOptionLong(): Unit {
        throw Exception('TODO')
    }

    public func testStopAtNonOptionShort(): Unit {
        throw Exception('TODO')
    }

    public func testStopAtUnexpectedArg(): Unit {
        throw Exception('TODO')
    }

    public func testStopBursting(): Unit {
        throw Exception('TODO')
    }

    public func testStopBursting2(): Unit {
        throw Exception('TODO')
    }

    public func testUnambiguousPartialLongOption1(): Unit {
        throw Exception('TODO')
    }

    public func testUnambiguousPartialLongOption2(): Unit {
        throw Exception('TODO')
    }

    public func testUnambiguousPartialLongOption3(): Unit {
        throw Exception('TODO')
    }

    public func testUnambiguousPartialLongOption4(): Unit {
        throw Exception('TODO')
    }

    public func testUnlimitedArgs(): Unit {
        throw Exception('TODO')
    }

    public func testUnrecognizedOption(): Unit {
        throw Exception('TODO')
    }

    public func testUnrecognizedOptionWithBursting(): Unit {
        throw Exception('TODO')
    }

    public func testWithRequiredOption(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

