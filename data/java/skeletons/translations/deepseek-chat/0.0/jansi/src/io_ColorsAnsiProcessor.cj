// Package: jansi
package jansi

// Imports Begin
import std.collection.ArrayList
import std.io.OutputStream
// Imports End

public open class ColorsAnsiProcessor <: AnsiProcessor {
    // Fields Begin
    var colors: AnsiColors = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(os: OutputStream, colors: AnsiColors) {
        super()
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processEscapeCommand<Object>(options: ArrayList<Any>, command: Int32): Bool {
        throw Exception('TODO')
    }

    protected override func processOperatingSystemCommand<Object>(options: ArrayList<Any>): Bool {
        throw Exception('TODO')
    }

    protected override func processCharsetSelect<Object>(options: ArrayList<Any>): Bool {
        throw Exception('TODO')
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

