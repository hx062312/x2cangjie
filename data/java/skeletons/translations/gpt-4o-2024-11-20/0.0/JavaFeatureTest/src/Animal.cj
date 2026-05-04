// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

open class Animal {
    // Fields Begin
    var name: String = ""
    var age: Int64 = 0
    // Fields End

    // Static Initializer Begin
    static init() {
                print("Static initializer: Animal class loaded")
    }

    // Static Initializer End

    // Methods Begin
    public init() {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(name: String) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(name: String, age: Int64) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getName(): String {
                return name
    }

    public open func getAge(): Int64 {
                return age
    }

    public open func speak(): String {
                return "Some sound"
    }

    // Methods End
}

