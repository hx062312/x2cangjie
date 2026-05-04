// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

open class MethodOverload {
    // Fields Begin
    // Fields End

    // Static Initializer Begin
    static init() {
                print("Static initializer: MethodOverload class loaded")
    }

    // Static Initializer End

    // Methods Begin
    public open func add(a: Int64, b: Int64): Int64 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func add(a: Float64, b: Float64): Float64 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func add(a: Int64, b: Int64, c: Int64): Int64 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func add(a: String, b: String): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func add(num: Int64, text: String): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func add(text: String, num: Int64): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func sum(): Int64 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func process(a: String, b: String): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func process(a: String): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    // Methods End
}

