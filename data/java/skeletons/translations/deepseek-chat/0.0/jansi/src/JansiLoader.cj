// Package: jansi
package jansi

// Imports Begin
import std.collection.ArrayList
import std.collection.LinkedList
import std.core.*
import std.fs.*
import std.io.*
import std.io.InputStream
import std.random.Random
import std.sync.*
// Imports End

public open class JansiLoader {
    // Fields Begin
    static var loaded: Bool = false
    static var nativeLibraryPath: String = throw Exception('TODO')
    static var nativeLibrarySourceUrl: String = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func initialize(): Bool {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func getNativeLibraryPath(): String {
                return nativeLibraryPath
    }

    public static func getNativeLibrarySourceUrl(): String {
                return nativeLibrarySourceUrl
    }

    private static func getTempDir(): File {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    static func cleanup(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private static func readNBytes(in__: InputStream, b: Array<Byte>): Int64 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private static func contentsEquals(in1: InputStream, in2: InputStream): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private static func extractAndLoadLibraryFile(libFolderForCurrentOS: String, libraryFileName: String, targetFolder: String): Bool {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private static func randomUUID(): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private static func loadNativeLibrary(libPath: File): Bool {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private static func loadJansiNativeLibrary(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private static func hasResource(path: String): Bool {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func getMajorVersion(): Int64 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func getMinorVersion(): Int64 {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func getVersion(): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    // Methods End
}

