// Package: jansi
package jansi

// Imports Begin
import std.io.OutputStream
// Imports End

public open class FastBufferedOutputStream {
    // Fields Begin
    let buf: Array<Byte> = throw Exception('TODO')  // Already translated, compilation failed
    var count: Int64 = 0
    // Fields End

    // Methods Begin
    public init(out: OutputStream) {
                super()
    }

    public open func write0(b: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func write1(b: Int8, off: Int64, len: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func flushBuffer(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func flush(): Unit {
                flushBuffer()
        // out.flush() // out is not defined in this class; assuming it's a field, but not present
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

