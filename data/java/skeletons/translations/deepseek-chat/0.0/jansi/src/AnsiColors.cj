// Package: jansi
package jansi

// Imports Begin

// Imports End

public open class AnsiColors {
    // Fields Begin
    var Colors16: Any = "16 colors"
    var Colors256: Any = "256 colors"
    var TrueColor: Any = "24-bit colors"
    let description: String = throw Exception('TODO')
    // Fields End

    // Methods Begin
    init(description: String) {
        throw Exception('TODO')
    }

    public open func getDescription(): String {
                return this.description
    }

    // Methods End

    protected init() {
        throw Exception('TODO')  // Already translated, compilation failed
    }
}

