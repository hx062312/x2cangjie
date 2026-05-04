// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

open class DerivedClass <: BaseClass {
    // Fields Begin
    var value: Int64 = 0
    // Fields End

    // Static Initializer Begin
    static init() {
                print("Static initializer: DerivedClass loaded")
    }

    // Static Initializer End

    // Methods Begin
    public init() {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(name: String, value: Int64) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getValue(): Int64 {
                return value
    }

    public override func introduce(): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    // Methods End
}

