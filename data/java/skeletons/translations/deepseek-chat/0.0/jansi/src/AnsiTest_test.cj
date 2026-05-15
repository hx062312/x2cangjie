// Package: jansi
package jansi

// Imports Begin
import std.sync.*
// Imports End

@Test
public open class AnsiTest {
    // Fields Begin
    // Fields End

    // Methods Begin
    public open func testSetEnabled(): Unit {
        throw Exception('TODO')
    }

    public open func testClone(): Unit {
        throw Exception('TODO')
    }

    public open func testApply(): Unit {
        throw Exception('TODO')
    }

    public open func testScrollUp(x: Int64, expected: String): Unit {
        throw Exception('TODO')
    }

    public open func testScrollDown(x: Int64, expected: String): Unit {
        throw Exception('TODO')
    }

    public open func testCursor(x: Int64, y: Int64, expected: String): Unit {
        throw Exception('TODO')
    }

    public open func testCursorToColumn(x: Int64, expected: String): Unit {
        throw Exception('TODO')
    }

    public open func testCursorUp(y: Int64, expected: String): Unit {
        throw Exception('TODO')
    }

    public open func testCursorDown(y: Int64, expected: String): Unit {
        throw Exception('TODO')
    }

    public open func testCursorRight(x: Int64, expected: String): Unit {
        throw Exception('TODO')
    }

    public open func testCursorLeft(x: Int64, expected: String): Unit {
        throw Exception('TODO')
    }

    public open func testCursorMove(x: Int64, y: Int64, expected: String): Unit {
        throw Exception('TODO')
    }

    public open func testCursorDownLine(): Unit {
        throw Exception('TODO')
    }

    public open func testCursorDownLine(n: Int64, expected: String): Unit {
        throw Exception('TODO')
    }

    public open func testCursorUpLine(): Unit {
        throw Exception('TODO')
    }

    public open func testCursorUpLine(n: Int64, expected: String): Unit {
        throw Exception('TODO')
    }

    public open func testColorDisabled(): Unit {
        throw Exception('TODO')
    }

    public open func testAnsiMainWithNoConsole(): Unit {
        throw Exception('TODO')
    }

    private static func assertAnsi(expected: String, actual: Ansi): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

