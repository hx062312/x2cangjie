// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

@Test
open class OptionTest {
    // Fields Begin
    // Fields End

    // Methods Begin
    private static func checkOption(option: Option, opt: String, description: String, longOpt: String, numArgs: Int64, argName: String, required: Bool, optionalArg: Bool, valueSeparator: Rune, cls: Type<Any>): Unit {
        throw Exception('TODO')
    }

    public func testBuilderInsufficientParams1(): Unit {
        throw Exception('TODO')
    }

    public func testBuilderInsufficientParams2(): Unit {
        throw Exception('TODO')
    }

    public func testBuilderInvalidOptionName1(): Unit {
        throw Exception('TODO')
    }

    public func testBuilderInvalidOptionName2(): Unit {
        throw Exception('TODO')
    }

    public func testBuilderInvalidOptionName3(): Unit {
        throw Exception('TODO')
    }

    public func testBuilderInvalidOptionName4(): Unit {
        throw Exception('TODO')
    }

    public func testBuilderMethods(): Unit {
        throw Exception('TODO')
    }

    public func testClear(): Unit {
        throw Exception('TODO')
    }

    public func testClone(): Unit {
        throw Exception('TODO')
    }

    public func testGetValue(): Unit {
        throw Exception('TODO')
    }

    public func testHasArgName(): Unit {
        throw Exception('TODO')
    }

    public func testHasArgs(): Unit {
        throw Exception('TODO')
    }

    public func testHashCode(): Unit {
        throw Exception('TODO')
    }

    public func testSubclass(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

open class DefaultOption <: Option {
    // Fields Begin
    static let serialVersionUID: Int64 = throw Exception('TODO')
    let defaultValue: String = throw Exception('TODO')
    // Fields End

    // Methods Begin
    init(opt: String, description: String, defaultValue: String) {
        throw Exception('TODO')
    }

    public func getValue(): String {
        throw Exception('TODO')
    }

    // Methods End
}

open class TestOption <: Option {
    // Fields Begin
    static let serialVersionUID: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    init(opt: String, hasArg: Bool, description: String) {
        throw Exception('TODO')
    }

    public func addValue(value: String): Bool {
        throw Exception('TODO')
    }

    // Methods End
}

