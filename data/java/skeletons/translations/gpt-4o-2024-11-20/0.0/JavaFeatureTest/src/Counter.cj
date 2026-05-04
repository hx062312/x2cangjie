// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

open class Counter {
    // Fields Begin
    static var instanceCount: Int64 = 0
    static var totalCount: Int64 = 0
    var name: String = ""
    var count: Int64 = 0
    // Fields End

    // Static Initializer Begin
    static init() {
                print("Static initializer: Counter class loaded")
        instanceCount = 0
        totalCount = 0
    }

    // Static Initializer End

    // Methods Begin
    public init() {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(name: String) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public init(name: String, initialCount: Int64) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func increment(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func increment(delta: Int64): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func reset(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getCount(): Int64 {
                return count
    }

    public open func getName(): String {
                return name
    }

    public static func getInstanceCount(): Int64 {
                return instanceCount
    }

    public static func getTotalCount(): Int64 {
                return totalCount
    }

    public static func resetAll(): Unit {
                totalCount = 0
    }

    // Methods End
}

