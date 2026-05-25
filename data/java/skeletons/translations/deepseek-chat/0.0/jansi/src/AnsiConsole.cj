// Package: jansi
package jansi

// Imports Begin
import std.core.*
import std.fs.*
import std.io.*
// Imports End

public open class AnsiConsole {
    // Fields Begin
    static let JANSI_OUT_COLORS: String = "jansi.out.colors"
    static let JANSI_ERR_COLORS: String = "jansi.err.colors"
    static let JANSI_COLORS_16: String = "16"
    static let JANSI_COLORS_256: String = "256"
    static let JANSI_COLORS_TRUECOLOR: String = "truecolor"
    static let JANSI_PASSTHROUGH: String = "jansi.passthrough"
    static let JANSI_STRIP: String = "jansi.strip"
    static let JANSI_FORCE: String = "jansi.force"
    static let JANSI_EAGER: String = "jansi.eager"
    static let JANSI_NORESET: String = "jansi.noreset"
    static let JANSI_GRACEFUL: String = "jansi.graceful"
    static var system_out: Any = throw Exception('TODO')  // Already translated, compilation failed
    static var out: Any = throw Exception('TODO')
    static var system_err: Any = throw Exception('TODO')  // Already translated, compilation failed
    static var err: Any = throw Exception('TODO')
    static let IS_WINDOWS: Bool = throw Exception('TODO')  // Already translated, compilation failed
    static let IS_CYGWIN: Bool = throw Exception('TODO')  // Already translated, compilation failed
    static let IS_MSYSTEM: Bool = throw Exception('TODO')  // Already translated, compilation failed
    static let IS_CONEMU: Bool = throw Exception('TODO')  // Already translated, compilation failed
    static let ENABLE_VIRTUAL_TERMINAL_PROCESSING: Int64 = 0x0004
    static var STDOUT_FILENO: Int64 = 1
    static var STDERR_FILENO: Int64 = 2
    static var initialized: Bool = false
    static var installed: Int64 = 0
    static var virtualProcessing: Int64 = 0
    static let JANSI_MODE: String = "jansi.mode"
    static let JANSI_OUT_MODE: String = "jansi.out.mode"
    static let JANSI_ERR_MODE: String = "jansi.err.mode"
    static let JANSI_MODE_STRIP: String = "strip"
    static let JANSI_MODE_FORCE: String = "force"
    static let JANSI_MODE_DEFAULT: String = "default"
    static let JANSI_COLORS: String = "jansi.colors"
    // Fields End

    // Static Initializer Begin
    static init() {
                if (getBoolean(JANSI_EAGER)) {
        initStreams()
        }
    }

    // Static Initializer End

    // Methods Begin
    public static func getTerminalWidth(): Int64 {
                var w: Int64 = out_method().getTerminalWidth()
        if (w <= 0) {
        w = err_method().getTerminalWidth()
        }
        return w
    }

    private init() {
                throw Exception("TODO")
    }

    private static func ansiStream(stdout: Bool): AnsiPrintStream {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    private static func newPrintStream(out: AnsiOutputStream, enc: String): AnsiPrintStream {
                if (enc != "") {
        try {
        return AnsiPrintStream(out, true, enc)
        } catch (e: Exception) {
        }
        }
        try {
        return AnsiPrintStream(out, true, "")
        } catch (e: Exception) {
        }
        return AnsiPrintStream(out, true, "")
    }

    static func getBoolean(name: String): Bool {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func out_method(): AnsiPrintStream {
        throw Exception('TODO')
    }

    public static func sysOut(): Any {
                return system_out
    }

    public static func err_method(): AnsiPrintStream {
        throw Exception('TODO')
    }

    public static func sysErr(): Any {
                return system_err
    }

    public static func systemInstall(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    public static func isInstalled(): Bool {
                return installed > 0
    }

    public static func systemUninstall(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    static func initStreams(): Unit {
        throw Exception('TODO')  // Already translated, compilation failed
    }

    // Methods End
}

