// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

open class Rectangle <: Shape {
    // Fields Begin
    var width: Float64 = 0.0
    var height: Float64 = 0.0
    // Fields End

    // Static Initializer Begin
    static init() {
                print("Static initializer: Rectangle class loaded")
    }

    // Static Initializer End

    // Methods Begin
    public init() {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(width: Float64, height: Float64) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(color: String, width: Float64, height: Float64) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getWidth(): Float64 {
                return width
    }

    public open func getHeight(): Float64 {
                return height
    }

    public override func getArea(): Float64 {
                return width * height
    }

    public override func getPerimeter(): Float64 {
                return 2.0 * (width + height)
    }

    // Methods End
}

