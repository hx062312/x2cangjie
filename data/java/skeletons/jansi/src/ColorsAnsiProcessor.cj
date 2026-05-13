// Package: jansi
package jansi

// Imports Begin
import jansi.io.AnsiProcessor
import std.collection.ArrayList
import std.io.OutputStream
// Imports End

public open class ColorsAnsiProcessor <: AnsiProcessor {
    // Fields Begin
    let colors: AnsiColors = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(os: OutputStream, colors: AnsiColors) {
        super()
        throw Exception('TODO')
    }

    protected override func processEscapeCommand(options: ArrayList<Any>, command: Int64): Bool {
        throw Exception('TODO')
    }

    protected override func processOperatingSystemCommand(options: ArrayList<Any>): Bool {
        throw Exception('TODO')
    }

    protected override func processCharsetSelect(options: ArrayList<Any>): Bool {
        throw Exception('TODO')
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

