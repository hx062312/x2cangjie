// Package: jansi
package jansi

// Imports Begin

// Imports End

public open class AnsiType {
    // Fields Begin
    var Native: Any = throw Exception("TODO")
    var Unsupported: Any = throw Exception('TODO')
    var VirtualTerminal: Any = "Supported through windows virtual terminal"
    var Emulation: Any = "Emulated through using windows API console commands"
    var Redirected: Any = "The stream is redirected to a file or a pipe"
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

