// Package: commons_codec
package commons_codec

// Imports Begin
// Imports End

open interface BinaryDecoder <: Decoder {
    // Fields Begin
    // Fields End

    // Methods Begin
    func decode(source: Array<Int8>): Array<Int8> {
        throw Exception('TODO')
    }

    // Methods End
}

