// Package: minimal
package minimal

// Imports Begin
import std.collection.ArrayList
import std.collection.HashMap
import std.collection.HashSet
import std.collection.List
import std.io.*
// Imports End

open class App {
    // Fields Begin
    static var globalCounter: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func greet(name: String): String {
        throw Exception('TODO')
    }

    public static func add(a: Int64, b: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func addWithDependency(box: MutableBox, audit: ArrayList<String>, label: String): Int64 {
        throw Exception('TODO')
    }

    public static func incrementGlobalCounter(): Int64 {
        throw Exception('TODO')
    }

    public static func getGlobalCounter(): Int64 {
        throw Exception('TODO')
    }

    public static func resetGlobalCounter(): Unit {
        throw Exception('TODO')
    }

    public static func appendTaggedValue(values: ArrayList<String>, raw: String): Unit {
        throw Exception('TODO')
    }

    public static func bumpBox(box: MutableBox, delta: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func filterAllowed(allowed: HashSet<String>, items: ArrayList<String>): ArrayList<String> {
        throw Exception('TODO')
    }

    public static func scoreOf(scores: HashMap<String, Int64>, key: String): Int64 {
        throw Exception('TODO')
    }

    public static func sumBuffer(buf: ByteBuffer): Int64 {
        throw Exception('TODO')
    }

    public static func readAll(reader: Any): String {
        throw Exception('TODO')
    }

    public static func appendLabel(writer: StringBuilder, label: String): Unit {
        throw Exception('TODO')
    }

    public static func describeScore(scored: Scored): String {
        throw Exception('TODO')
    }

    // Methods End
}

open class MutableBox {
    // Fields Begin
    var value: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(value: Int64) {
        throw Exception('TODO')
    }

    public open func getValue(): Int64 {
        throw Exception('TODO')
    }

    public open func setValue(value: Int64): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

main(): Unit {
    throw Exception('TODO')
}
