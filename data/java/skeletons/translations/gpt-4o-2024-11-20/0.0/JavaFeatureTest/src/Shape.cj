// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

abstract class Shape {
    // Fields Begin
    var color: String = ""
    // Fields End

    // Static Initializer Begin
    static init() {
                print("Static initializer: Shape class loaded")
    }

    // Static Initializer End

    // Methods Begin
    public init() {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(color: String) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getColor(): String {
                return color
    }

    public open func getArea(): Float64 {
                throw Exception('TODO')
    }

    public open func getPerimeter(): Float64 {
                throw Exception('TODO')
    }

    public open func describe(): String {
                return "A shape with color " + color
    }

    // Methods End
}

