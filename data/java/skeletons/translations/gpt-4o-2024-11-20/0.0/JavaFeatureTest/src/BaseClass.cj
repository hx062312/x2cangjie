// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

open class BaseClass {
    // Fields Begin
    var name: String = ""
    // Fields End

    // Static Initializer Begin
    static init() {
                print("Static initializer: BaseClass loaded")
    }

    // Static Initializer End

    // Methods Begin
    public init() {
                self.name = "Base"
    }

    public init(name: String) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getName(): String {
                return name
    }

    public open func introduce(): String {
                return "I am " + name
    }

    // Methods End
}

