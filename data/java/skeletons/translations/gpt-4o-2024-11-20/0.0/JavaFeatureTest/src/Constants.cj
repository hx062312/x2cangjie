// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

class Constants {
    // Fields Begin
    static var instanceCount: Int64 = 0
    let id: Int64 = 0
    let name: String = ""
    static let MAX_SIZE: Int64 = 100
    static let APP_NAME: String = "JavaFeatureTest"
    static let PI: Float64 = 3.141592653589793
    // Fields End

    // Static Initializer Begin
    static init() {
                print("Static initializer: Constants class loaded")
        instanceCount = 0
    }

    // Static Initializer End

    // Methods Begin
    public init(id: Int64, name: String) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getId(): Int64 {
                return id
    }

    public open func getName(): String {
                return name
    }

    // Methods End
}

