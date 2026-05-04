// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

open class OuterClass {
    // Fields Begin
    var outerName: String = ""
    static var staticOuterName: String = "StaticOuter"
    // Fields End

    // Static Initializer Begin
    static init() {
                print("Static initializer: OuterClass loaded")
    }

    // Static Initializer End

    // Methods Begin
    public init(outerName: String) {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getOuterName(): String {
                return outerName
    }

    public open func createPrivateInner(value: String): Any {
        throw Exception('TODO')
    }

    // Methods End
}

open class StaticInnerClass {
    // Fields Begin
    var staticValue: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(value: Int64) {
        throw Exception('TODO')
    }

    public open func getStaticValue(): Int64 {
        throw Exception('TODO')
    }

    public open func getOuterStaticName(): String {
        throw Exception('TODO')
    }

    // Methods End
}

open class MemberInnerClass {
    // Fields Begin
    var memberValue: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(memberValue: Int64) {
        throw Exception('TODO')
    }

    public open func getMemberValue(): Int64 {
        throw Exception('TODO')
    }

    public open func getOuterName(): String {
        throw Exception('TODO')
    }

    public open func getOuterInfo(): String {
        throw Exception('TODO')
    }

    // Methods End
}

open class PrivateInnerClass {
    // Fields Begin
    var privateValue: String = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(privateValue: String) {
        throw Exception('TODO')
    }

    public open func getPrivateValue(): String {
        throw Exception('TODO')
    }

    public open func accessOuter(): String {
        throw Exception('TODO')
    }

    // Methods End
}

