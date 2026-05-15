// Package: jansi
package jansi

// Imports Begin

// Imports End

public open class AnsiMode {
    // Fields Begin
    var Strip: Any = "Strip all ansi sequences"
    var Default: Any = "Print ansi sequences if the stream is a terminal"
    var Force: Any = throw Exception('TODO')
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

