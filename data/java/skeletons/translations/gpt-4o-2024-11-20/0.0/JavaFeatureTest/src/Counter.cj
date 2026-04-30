// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

open class Counter {
    // Fields Begin
    static var instanceCount: Int64 = throw Exception('TODO')
    static var totalCount: Int64 = throw Exception('TODO')
    var name: String = throw Exception('TODO')
    var count: Int64 = throw Exception('TODO')
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public init(name: String) {
        throw Exception('TODO')
    }

    public init(name: String, initialCount: Int64) {
        throw Exception('TODO')
    }

    public open func increment(): Unit {
        throw Exception('TODO')
    }

    public open func increment(delta: Int64): Unit {
        throw Exception('TODO')
    }

    public open func reset(): Unit {
        throw Exception('TODO')
    }

    public open func getCount(): Int64 {
        throw Exception('TODO')
    }

    public open func getName(): String {
        throw Exception('TODO')
    }

    public static func getInstanceCount(): Int64 {
        throw Exception('TODO')
    }

    public static func getTotalCount(): Int64 {
        throw Exception('TODO')
    }

    public static func resetAll(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

