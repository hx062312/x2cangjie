// Package: commons_codec.binary
package commons_codec.binary

// Imports Begin
// Imports End

open class BaseNCodecOutputStream <: FilterOutputStream {
    // Fields Begin
    let doEncode: Bool = throw Exception('TODO')
    let baseNCodec: Any = throw Exception('TODO')
    let singleByte: Array<Int8> = throw Exception('TODO')
    let context: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(output: OutputStream, basedCodec: Any, doEncode: Bool) {
        throw Exception('TODO')
    }

    public func close(): Unit {
        throw Exception('TODO')
    }

    public func eof(): Unit {
        throw Exception('TODO')
    }

    public open func flush(): Unit {
        throw Exception('TODO')
    }

    private open func flush(propagate: Bool): Unit {
        throw Exception('TODO')
    }

    public func isStrictDecoding(): Bool {
        throw Exception('TODO')
    }

    public open func write(array: Int8, offset: Int64, len: Int64): Unit {
        throw Exception('TODO')
    }

    public open func write(i: Int64): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

