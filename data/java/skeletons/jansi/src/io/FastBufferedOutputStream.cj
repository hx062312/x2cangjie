// Package: jansi.io
package jansi.io

// Imports Begin
// Imports End

class FastBufferedOutputStream <: FilterOutputStream {
    // Fields Begin
    let buf: Array<Int8> = throw Exception('TODO')
    var count: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(out: OutputStream) {
        throw Exception('TODO')
    }

    private func flushBuffer(): Unit {
        throw Exception('TODO')
    }

    public func flush(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

