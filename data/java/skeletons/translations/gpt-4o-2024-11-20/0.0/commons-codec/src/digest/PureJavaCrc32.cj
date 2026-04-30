// Package: commons_codec.digest
package commons_codec.digest

// Imports Begin
// Imports End

open class PureJavaCrc32 <: Checksum {
    // Fields Begin
    static let T: Array<Int64> = throw Exception('TODO')
    var crc: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public func getValue(): Int64 {
        throw Exception('TODO')
    }

    public func reset(): Unit {
        throw Exception('TODO')
    }

    private func _reset(): Unit {
        throw Exception('TODO')
    }

    public open func update(b: Array<Int8>, offset: Int64, len: Int64): Unit {
        throw Exception('TODO')
    }

    public func update(b: Int64): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

