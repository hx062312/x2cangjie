// Package: jansi
package jansi

// Imports Begin

// Imports End

public open class AnsiType {
    // Fields Begin
    var Native: Any = throw Exception("TODO")
    var Unsupported: Any = throw Exception('Ansi sequences are stripped out')
    var VirtualTerminal: Any = throw Exception("Supported through windows virtual terminal")
    var Emulation: Any = throw Exception('TODO')
    var Redirected: Any = throw Exception("The stream is redirected to a file or a pipe")
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

