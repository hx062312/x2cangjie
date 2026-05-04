// Package: RagTestProject
package RagTestProject

// Imports Begin
import std.collection.*
import std.collection.ArrayList
// Imports End

open class StudentManager {
    // Fields Begin
    var students: ArrayList<Student> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public open func addStudent(student: Student): Unit {
        throw Exception('TODO')
    }

    public open func findStudentByName(name: String): Option<Student> {
        throw Exception('TODO')
    }

    public open func getTopStudent(): Option<Student> {
        throw Exception('TODO')
    }

    public open func getClassAverage(): Float64 {
        throw Exception('TODO')
    }

    public open func getStudentsByGrade(subject: String, threshold: Int64): HashMap<String, ArrayList<String>> {
        throw Exception('TODO')
    }

    // Methods End
}

