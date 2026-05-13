// Package: jansi.internal
package jansi.internal

// Imports Begin
import std.collection.HashMap
import std.io.*
import std.process.*
// Imports End

open class OSInfo {
    // Fields Begin
    static let X86: String = throw Exception('TODO')
    static let X86_64: String = throw Exception('TODO')
    static let IA64_32: String = throw Exception('TODO')
    static let IA64: String = throw Exception('TODO')
    static let PPC: String = throw Exception('TODO')
    static let PPC64: String = throw Exception('TODO')
    static let ARM64: String = throw Exception('TODO')
    static let archMapping: HashMap<String, String> = throw Exception('TODO')
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    public static func getNativeLibFolderPathForCurrentOS(): String {
        throw Exception('TODO')
    }

    public static func getOSName(): String {
        throw Exception('TODO')
    }

    public static func isAndroid(): Bool {
        throw Exception('TODO')
    }

    public static func isAlpine(): Bool {
        throw Exception('TODO')
    }

    static func getHardwareName(): String {
        throw Exception('TODO')
    }

    private static func readFully(in: InputStream): String {
        throw Exception('TODO')
    }

    static func resolveArmArchType(): String {
        throw Exception('TODO')
    }

    public static func getArchName(): String {
        throw Exception('TODO')
    }

    static func translateOSNameToFolderName(osName: String): String {
        throw Exception('TODO')
    }

    static func translateArchNameToFolderName(archName: String): String {
        throw Exception('TODO')
    }

    // Methods End
}

main(): Unit {
    throw Exception('TODO')
}
