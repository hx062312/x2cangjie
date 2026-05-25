// Package: jansi
package jansi

// Imports Begin
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
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processEscapeCommand(options: ArrayList<Object>, command: Int64): Bool {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    protected override func processOperatingSystemCommand(options: ArrayList<Object>): Bool {
                return false
    }

    protected override func processCharsetSelect0(options: ArrayList<Object>): Bool {
                return false
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

