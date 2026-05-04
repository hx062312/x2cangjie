// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

open class Dog <: Animal {
    // Fields Begin
    var breed: String = ""
    // Fields End

    // Static Initializer Begin
    static init() {
                print("Static initializer: Dog class loaded")
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

    public init(name: String, age: Int64, breed: String) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getBreed(): String {
                return breed
    }

    public override func speak(): String {
                return "Woof!"
    }

    public open func fetch(): String {
                return "Fetching the ball!"
    }

    // Methods End
}

