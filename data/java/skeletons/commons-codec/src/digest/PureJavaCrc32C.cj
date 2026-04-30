// Package: commons_codec.digest
package commons_codec.digest

// Imports Begin
// Imports End

open class PureJavaCrc32C <: Checksum {
    // Fields Begin
    static let T8_0_start: Int64 = throw Exception('TODO')
    static let T8_1_start: Int64 = throw Exception('TODO')
    static let T8_2_start: Int64 = throw Exception('TODO')
    static let T8_3_start: Int64 = throw Exception('TODO')
    static let T8_4_start: Int64 = throw Exception('TODO')
    static let T8_5_start: Int64 = throw Exception('TODO')
    static let T8_6_start: Int64 = throw Exception('TODO')
    static let T8_7_start: Int64 = throw Exception('TODO')
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

    public open func update(b: Array<Int8>, off: Int64, len: Int64): Unit {
        throw Exception('TODO')
    }

    public func update(b: Int64): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

