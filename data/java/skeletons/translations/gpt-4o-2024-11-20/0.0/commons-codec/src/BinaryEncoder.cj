// Package: commons_codec
package commons_codec

// Imports Begin
// Imports End

open interface BinaryEncoder <: Encoder {
    // Fields Begin
    // Fields End

    // Methods Begin
    func encode(source: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    // Methods End
}

