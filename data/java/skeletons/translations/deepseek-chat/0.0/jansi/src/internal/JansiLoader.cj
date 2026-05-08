// Package: jansi.internal
package jansi.internal

// Imports Begin
// No additional imports needed for Thread in Cangjie
import std.collection.ArrayList
import std.fs.*
import std.random.Random
// Imports End

open class JansiLoader {
    // Fields Begin
    static var loaded: Bool = throw Exception('TODO')
    static var nativeLibraryPath: String = throw Exception('TODO')
    static var nativeLibrarySourceUrl: String = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func initialize(): Bool {
        throw Exception('TODO')
    }

    public static func getNativeLibraryPath(): String {
        throw Exception('TODO')
    }

    public static func getNativeLibrarySourceUrl(): String {
        throw Exception('TODO')
    }

    private static func getTempDir(): File {
        throw Exception('TODO')
    }

    static func cleanup(): Unit {
        throw Exception('TODO')
    }

    private static func readNBytes(in: InputStream, b: Array<Byte>): Int64 {
        throw Exception('TODO')
    }

    private static func contentsEquals(in1: InputStream, in2: InputStream): String {
        throw Exception('TODO')
    }

    private static func extractAndLoadLibraryFile(libFolderForCurrentOS: String, libraryFileName: String, targetFolder: String): Bool {
        throw Exception('TODO')
    }

    private static func randomUUID(): String {
        throw Exception('TODO')
    }

    private static func loadNativeLibrary(libPath: File): Bool {
        throw Exception('TODO')
    }

    private static func loadJansiNativeLibrary(): Unit {
        throw Exception('TODO')
    }

    private static func hasResource(path: String): Bool {
        throw Exception('TODO')
    }

    public static func getMajorVersion(): Int64 {
        throw Exception('TODO')
    }

    public static func getMinorVersion(): Int64 {
        throw Exception('TODO')
    }

    public static func getVersion(): String {
        throw Exception('TODO')
    }

    // Methods End
}

