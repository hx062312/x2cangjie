// Package: jansi.io
package jansi.io

// Imports Begin
import std.collection.ArrayList
// Imports End

open class ColorsAnsiProcessor <: AnsiProcessor {
    // Fields Begin
    let colors: AnsiColors = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(os: OutputStream, colors: AnsiColors) {
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
}

