// Package: RagTestProject
package RagTestProject

// Imports Begin
import std.collection.*
// Imports End

open class Student {
    // Fields Begin
    var name: String = ""
    var age: Int64 = 0
    var grades: HashMap<String, Int64> = HashMap<String, Int64>()
    // Fields End

    // Methods Begin
    public init(name: String, age: Int64) {
                this.name = name; this.age = age; this.grades = HashMap<String, Int64>();
    }

    public open func getName(): String {
                return name
    }

    public open func getAge(): Int64 {
                return age
    }

    public open func addGrade(subject: String, score: Int64): Unit {
                grades.put(subject, score)
    }

    public open func getGrade(subject: String): Int64 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getAverageGrade(): Float64 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getGradeStatus(subject: String): Option<String> {
                let score = grades.get(subject)
        match (score) {
        case None => return None<String>
        case Some(value) => if (value >= 60) {
        return Some("passed")
        } else {
        return Some("failed")
        }
        }
    }

    // Methods End
}

