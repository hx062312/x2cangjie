// Package: RagTestProject
package RagTestProject

// Imports Begin
import std.collection.*
// Imports End

open class Student {
    // Fields Begin
    var name: String = throw Exception('TODO')
    var age: Int64 = throw Exception('TODO')
    var grades: HashMap<String, Int64> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(name: String, age: Int64) {
        throw Exception('TODO')
    }

    public open func getName(): String {
        throw Exception('TODO')
    }

    public open func getAge(): Int64 {
        throw Exception('TODO')
    }

    public open func addGrade(subject: String, score: Int64): Unit {
        throw Exception('TODO')
    }

    public open func getGrade(subject: String): Int64 {
        throw Exception('TODO')
    }

    public open func getAverageGrade(): Float64 {
        throw Exception('TODO')
    }

    public open func getGradeStatus(subject: String): Option<String> {
        throw Exception('TODO')
    }

    // Methods End
}

