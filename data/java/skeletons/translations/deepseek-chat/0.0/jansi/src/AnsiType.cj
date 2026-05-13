// Package: jansi
package jansi

// Imports Begin

// Imports End

open class AnsiType {
    // Fields Begin
    var Native: Any = throw Exception('TODO')
    var Unsupported: Any = throw Exception('TODO')
    var VirtualTerminal: Any = throw Exception('TODO')
    var Emulation: Any = throw Exception('TODO')
    var Redirected: Any = throw Exception('TODO')
    let description: String = throw Exception('TODO')
    // Fields End

    // Methods Begin
    init(description: String) {
        throw Exception('TODO')
    }

    open func getDescription(): String {
        throw Exception('TODO')
    }

    // Methods End
}

