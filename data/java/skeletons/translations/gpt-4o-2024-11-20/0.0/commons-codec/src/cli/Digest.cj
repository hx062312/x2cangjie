// Package: commons_codec.cli
package commons_codec.cli

// Imports Begin
// Imports End

open class Digest {
    // Fields Begin
    let algorithm: String = throw Exception('TODO')
    let args: Array<String> = throw Exception('TODO')
    let inputs: Array<String> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private init(args: Array<String>) {
        throw Exception('TODO')
    }

    private open func println(prefix: String, digest: Array<Int8>): Unit {
        throw Exception('TODO')
    }

    private open func println(prefix: String, digest: Array<Int8>, fileName: String): Unit {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

