// Package: jansi
package jansi

// Imports Begin
import std.collection.*
import std.collection.ArrayList
import std.io.OutputStream
// Imports End

public open class ColorsAnsiProcessor <: AnsiProcessor {
    // Fields Begin
    var colors: AnsiColors = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(os_param: OutputStream, colors_param: AnsiColors) {
        super()
        throw Exception('TODO')
    }

    protected override func processEscapeCommand(options: ArrayList<Any>, command: Int32): Bool {
        throw Exception('TODO')
    }

    protected override func processOperatingSystemCommand(options: ArrayList<Any>): Bool {
        throw Exception('TODO')
    }

    protected override func processCharsetSelect0(options: ArrayList<Any>): Bool {
        throw Exception('TODO')
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

