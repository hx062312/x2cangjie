// Package: commons_codec
package commons_codec

// Imports Begin
// Imports End

open interface StringEncoder <: Encoder {
    // Fields Begin
    // Fields End

    // Methods Begin
    func encode(source: String): String {
        throw Exception('TODO')
    }

    // Methods End
}

