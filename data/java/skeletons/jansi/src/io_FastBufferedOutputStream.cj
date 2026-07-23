// Package: jansi
package jansi

// Imports Begin
import std.io.OutputStream
// Imports End

public open class FastBufferedOutputStream {
    // Fields Begin
    var buf: Array<Int8> = throw Exception('TODO')
    var count: Int32 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(out: OutputStream) {
        throw Exception('TODO')
    }

    public open func write0(b: Int32): Unit {
        throw Exception('TODO')
    }

    public open func write1(b: Int8, off: Int32, len: Int32): Unit {
        throw Exception('TODO')
    }

    private func flushBuffer(): Unit {
        throw Exception('TODO')
    }

    public open func flush(): Unit {
        throw Exception('TODO')
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

