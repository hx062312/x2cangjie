// Package: RagTestProject
package RagTestProject

// Imports Begin
import std.collection.*
import std.collection.ArrayList
// Imports End

open class StudentManager {
    // Fields Begin
    var students: ArrayList<Student> = ArrayList<Student>()
    // Fields End

    // Methods Begin
    public init() {
                students = ArrayList<Student>()
    }

    public open func addStudent(student: Student): Unit {
                students.add(student)
    }

    public open func findStudentByName(name: String): Option<Student> {
                for (s in students) {
        if (s.getName() == name) {
        return Some(s)
        }
        }
        return None
    }

    public open func getTopStudent(): Option<Student> {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getClassAverage(): Float64 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public open func getStudentsByGrade(subject: String, threshold: Int64): HashMap<String, ArrayList<String>> {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    // Methods End
}

