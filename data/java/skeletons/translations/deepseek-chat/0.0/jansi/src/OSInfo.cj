// Package: jansi
package jansi

// Imports Begin
import std.collection.*
import std.collection.HashMap
import std.core.*
import std.io.InputStream
import std.process.*
// Imports End

public open class OSInfo {
    // Fields Begin
    static let X86: String = "x86"
    static let X86_64: String = "x86_64"
    static let IA64_32: String = "ia64_32"
    static let IA64: String = "ia64"
    static let PPC: String = "ppc"
    static let PPC64: String = "ppc64"
    static let ARM64: String = "arm64"
    static let archMapping: HashMap<String, String> = HashMap<String, String>()
    // Fields End

    // Static Initializer Begin
    static init() {
                archMapping[X86] = X86
        archMapping["i386"] = X86
        archMapping["i486"] = X86
        archMapping["i586"] = X86
        archMapping["i686"] = X86
        archMapping["pentium"] = X86
        archMapping[X86_64] = X86_64
        archMapping["amd64"] = X86_64
        archMapping["em64t"] = X86_64
        archMapping["universal"] = X86_64
        archMapping[IA64] = IA64
        archMapping["ia64w"] = IA64
        archMapping[IA64_32] = IA64_32
        archMapping["ia64n"] = IA64_32
        archMapping[PPC] = PPC
        archMapping["power"] = PPC
        archMapping["powerpc"] = PPC
        archMapping["power_pc"] = PPC
        archMapping["power_rs"] = PPC
        archMapping[PPC64] = PPC64
        archMapping["power64"] = PPC64
        archMapping["powerpc64"] = PPC64
        archMapping["power_pc64"] = PPC64
        archMapping["power_rs64"] = PPC64
        archMapping["aarch64"] = ARM64
    }

    // Static Initializer End

    // Methods Begin
    public static func getNativeLibFolderPathForCurrentOS(): String {
                return getOSName() + "/" + getArchName()
    }

    public static func getOSName(): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func isAndroid(): Bool {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func isAlpine(): Bool {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    static func getHardwareName(): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private static func readFully(in__: InputStream): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    static func resolveArmArchType(): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func getArchName(): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    static func translateOSNameToFolderName(osName: String): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    static func translateArchNameToFolderName(archName: String): String {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    // Methods End
}

