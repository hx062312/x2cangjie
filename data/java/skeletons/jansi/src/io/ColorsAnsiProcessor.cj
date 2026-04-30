// Package: jansi.io
package jansi.io

// Imports Begin
// Imports End

class ColorsAnsiProcessor <: AnsiProcessor {
    // Fields Begin
    let colors: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(os: OutputStream, colors: Any) {
        throw Exception('TODO')
    }

    protected func processEscapeCommand(options: ArrayList<Any>, command: Int64): Bool {
        throw Exception('TODO')
    }

    protected func processOperatingSystemCommand(options: ArrayList<Any>): Bool {
        throw Exception('TODO')
    }

    protected func processCharsetSelect(options: ArrayList<Any>): Bool {
        throw Exception('TODO')
    }

    // Methods End
}

