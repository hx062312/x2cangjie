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
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func write(b: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func write(b: Int8, off: Int64, len: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private func flushBuffer(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func flush(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

