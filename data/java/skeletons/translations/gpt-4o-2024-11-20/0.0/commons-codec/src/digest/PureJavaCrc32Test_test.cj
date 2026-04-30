// Package: commons_codec.digest
package commons_codec.digest

// Imports Begin
// Imports End

@Test
open class PureJavaCrc32Test {
    // Fields Begin
    let theirs: Any = throw Exception('TODO')
    let ours: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public func testCorrectness(): Unit {
        throw Exception('TODO')
    }

    private func checkOnBytes(bytes: Array<Int8>, print: Bool): Unit {
        throw Exception('TODO')
    }

    private func checkSame(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

open class Table {
    // Fields Begin
    let tables: Array<Array<Int64>> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private init(nBits: Int64, nTables: Int64, polynomial: Int64) {
        throw Exception('TODO')
    }

    func toStrings(nameformat: String): Array<String> {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

open class PerformanceTest {
    // Fields Begin
    static let MAX_LEN: Int64 = throw Exception('TODO')
    static let BYTES_PER_SIZE: Int64 = throw Exception('TODO')
    static let zip: Type<Any> = throw Exception('TODO')
    static let CRCS: ArrayList<Type<Any>> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private static func printCell(s: String, width: Int64, out: Any): Unit {
        throw Exception('TODO')
    }

    private static func doBench(crcs: ArrayList<Type<Any>>, out: Any): Unit {
        throw Exception('TODO')
    }

    private static func doBench(crcs: ArrayList<Type<Any>>, bytes: Array<Int8>, size: Int64, out: Any): Unit {
        throw Exception('TODO')
    }

    private static func doBench(clazz: Type<Any>, numThreads: Int64, bytes: Array<Int8>, size: Int64): Any {
        throw Exception('TODO')
    }

    private static func printSystemProperties(out: Any): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

open class BenchResult {
    // Fields Begin
    let value: Int64 = throw Exception('TODO')
    let mbps: Float64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    init(value: Int64, mbps: Float64) {
        throw Exception('TODO')
    }

    // Methods End
}

main(): Unit {
    throw Exception('TODO')
}
