// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

open class Bird <: Animal {
    // Fields Begin
    var wingSpan: Int64 = 0
    // Fields End

    // Static Initializer Begin
    static init() {
                print("Static initializer: Bird class loaded")
    }

    // Static Initializer End

    // Methods Begin
    public init() {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(name: String) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(name: String, age: Int64, wingSpan: Int64) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getWingSpan(): Int64 {
                return wingSpan
    }

    public open func fly(): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public override func speak(): String {
                return "Chirp!"
    }

    // Methods End
}

