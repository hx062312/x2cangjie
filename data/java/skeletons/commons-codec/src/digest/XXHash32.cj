// Package: commons_codec.digest
package commons_codec.digest

// Imports Begin
// Imports End

open class XXHash32 <: Checksum {
    // Fields Begin
    static let BUF_SIZE: Int64 = throw Exception('TODO')
    static let ROTATE_BITS: Int64 = throw Exception('TODO')
    static let PRIME1: Int64 = throw Exception('TODO')
    static let PRIME2: Int64 = throw Exception('TODO')
    static let PRIME3: Int64 = throw Exception('TODO')
    static let PRIME4: Int64 = throw Exception('TODO')
    static let PRIME5: Int64 = throw Exception('TODO')
    let oneByte: Array<Int8> = throw Exception('TODO')
    let state: Array<Int64> = throw Exception('TODO')
    let buffer: Array<Int8> = throw Exception('TODO')
    let seed: Int64 = throw Exception('TODO')
    var totalLen: Int64 = throw Exception('TODO')
    var pos: Int64 = throw Exception('TODO')
    var stateUpdated: Bool = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public init(seed: Int64) {
        throw Exception('TODO')
    }

    public func reset(): Unit {
        throw Exception('TODO')
    }

    public open func update(b: Int64): Unit {
        throw Exception('TODO')
    }

    public open func update(b: Array<Int8>, off: Int64, len: Int64): Unit {
        throw Exception('TODO')
    }

    public func getValue(): Int64 {
        throw Exception('TODO')
    }

    private static func getInt(buffer: Array<Int8>, idx: Int64): Int64 {
        throw Exception('TODO')
    }

    private func initializeState(): Unit {
        throw Exception('TODO')
    }

    private func process(b: Array<Int8>, offset: Int64): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

