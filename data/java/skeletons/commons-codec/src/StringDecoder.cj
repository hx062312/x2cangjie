// Package: commons_codec
package commons_codec

// Imports Begin
// Imports End

open interface StringDecoder <: Decoder {
    // Fields Begin
    // Fields End

    // Methods Begin
    func decode(source: String): String {
        throw Exception('TODO')
    }

    // Methods End
}

