// Package: commons_cli
package commons_cli

// Imports Begin
import std.fs.*
import std.reflect.TypeInfo
import std.time.DateTime
import stdx.encoding.url.URL
// Imports End

public open class TypeHandler {
    // Fields Begin
    // Fields End

    // Methods Begin
    public static func createClass(classname: String): TypeInfo {
        throw Exception('TODO')
    }

    public static func createDate(str: String): DateTime {
        throw Exception('TODO')
    }

    public static func createFile(str: String): File {
        throw Exception('TODO')
    }

    public static func createFiles(str: String): Array<File> {
        throw Exception('TODO')
    }

    public static func createNumber(str: String): Int64 {
        throw Exception('TODO')
    }

    public static func createObject(classname: String): Any {
        throw Exception('TODO')
    }

    public static func createURL(str: String): URL {
        throw Exception('TODO')
    }

    public static func createValue0<T>(str: String, clazz: TypeInfo): T {
        throw Exception('TODO')
    }

    public static func createValue1(str: String, obj: Any): Any {
        throw Exception('TODO')
    }

    public static func openFile(str: String): File {
        throw Exception('TODO')
    }

    // Methods End
}

