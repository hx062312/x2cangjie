// Package: commons_codec.binary
package commons_codec.binary

// Imports Begin
// Imports End

open class BaseNCodecInputStream <: FilterInputStream {
    // Fields Begin
    let baseNCodec: Any = throw Exception('TODO')
    let doEncode: Bool = throw Exception('TODO')
    let singleByte: Array<Int8> = throw Exception('TODO')
    let buf: Array<Int8> = throw Exception('TODO')
    let context: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    protected init(input: InputStream, baseNCodec: Any, doEncode: Bool) {
        throw Exception('TODO')
    }

    public func available(): Int64 {
        throw Exception('TODO')
    }

    public func isStrictDecoding(): Bool {
        throw Exception('TODO')
    }

    public func mark(readLimit: Int64): Unit {
        throw Exception('TODO')
    }

    public func markSupported(): Bool {
        throw Exception('TODO')
    }

    public open func read(): Int64 {
        throw Exception('TODO')
    }

    public open func read(array: Int8, offset: Int64, len: Int64): Int64 {
        throw Exception('TODO')
    }

    public func reset(): Unit {
        throw Exception('TODO')
    }

    public func skip(n: Int64): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

