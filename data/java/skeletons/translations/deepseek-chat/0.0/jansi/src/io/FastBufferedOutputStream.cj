// Package: jansi.io
package jansi.io

// Imports Begin

// Imports End

open class FastBufferedOutputStream <: FilterOutputStream {
    // Fields Begin
    let buf: Array<Byte> = throw Exception('TODO')
    var count: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(out: OutputStream) {
        throw Exception('TODO')
    }

    public open func write(b: Int64): Unit {
        throw Exception('TODO')
    }

    public open func write(b: Int8, off: Int64, len: Int64): Unit {
        throw Exception('TODO')
    }

    private func flushBuffer(): Unit {
        throw Exception('TODO')
    }

    public open func flush(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

