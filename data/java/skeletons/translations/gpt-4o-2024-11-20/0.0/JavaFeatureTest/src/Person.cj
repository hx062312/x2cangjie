// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

open class Person {
    // Fields Begin
    var name: String = ""
    var age: Int64 = 0
    var id: String = ""
    // Fields End

    // Static Initializer Begin
    static init() {
                print("Static initializer: Person class loaded")
    }

    // Static Initializer End

    // Methods Begin
    public init(name: String, age: Int64, id: String) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getName(): String {
                return name
    }

    public open func getAge(): Int64 {
                return age
    }

    public open func getId(): String {
                return id
    }

    public open func toString(): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func equals(obj: Any): Bool {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func hashCode(): Int64 {
                var result = name.hashCode()
        result = 31 * result + age
        result = 31 * result + id.hashCode()
        return result
    }

    // Methods End
}

