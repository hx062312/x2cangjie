// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

open class Calculator {
    // Fields Begin
    var result: Int64 = 0
    var name: String = ""
    // Fields End

    // Static Initializer Begin
    static init() {
                print("Static initializer: Calculator class is being loaded")
    }

    // Static Initializer End

    // Methods Begin
    public init() {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(initialValue: Int64) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(initialValue: Int64, name: String) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

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

    public open func getResult(): Int64 {
                return result
    }

    public open func getName(): String {
                return name
    }

    // Methods End
}

