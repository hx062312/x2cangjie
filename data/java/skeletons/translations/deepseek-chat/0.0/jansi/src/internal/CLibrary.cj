// Package: jansi.internal
package jansi.internal

// Imports Begin

// Imports End

open class CLibrary {
    // Fields Begin
    static let LOADED: Bool = throw Exception('TODO')
    static var STDOUT_FILENO: Int64 = throw Exception('TODO')
    static var STDERR_FILENO: Int64 = throw Exception('TODO')
    static var HAVE_ISATTY: Bool = throw Exception('TODO')
    static var HAVE_TTYNAME: Bool = throw Exception('TODO')
    static var TCSANOW: Int64 = throw Exception('TODO')
    static var TCSADRAIN: Int64 = throw Exception('TODO')
    static var TCSAFLUSH: Int64 = throw Exception('TODO')
    static var TIOCGETA: Int64 = throw Exception('TODO')
    static var TIOCSETA: Int64 = throw Exception('TODO')
    static var TIOCGETD: Int64 = throw Exception('TODO')
    static var TIOCSETD: Int64 = throw Exception('TODO')
    static var TIOCGWINSZ: Int64 = throw Exception('TODO')
    static var TIOCSWINSZ: Int64 = throw Exception('TODO')
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    private static func init(): Unit {
        throw Exception('TODO')
    }

    public static func isatty(fd: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func ttyname(filedes: Int64): String {
        throw Exception('TODO')
    }

    public static func openpty(amaster: Array<Int64>, aslave: Array<Int64>, name: Array<Byte>, termios: Termios, winsize: WinSize): Int64 {
        throw Exception('TODO')
    }

    public static func tcgetattr(filedes: Int64, termios: Termios): Int64 {
        throw Exception('TODO')
    }

    public static func tcsetattr(filedes: Int64, optional_actions: Int64, termios: Termios): Int64 {
        throw Exception('TODO')
    }

    public static func ioctl(filedes: Int64, request: Int64, params: Array<Int64>): Int64 {
        throw Exception('TODO')
    }

    public static func ioctl(filedes: Int64, request: Int64, params: WinSize): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

open class WinSize {
    // Fields Begin
    static var SIZEOF: Int64 = throw Exception('TODO')
    var ws_row: Int16 = throw Exception('TODO')
    var ws_col: Int16 = throw Exception('TODO')
    var ws_xpixel: Int16 = throw Exception('TODO')
    var ws_ypixel: Int16 = throw Exception('TODO')
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    private static func init(): Unit {
        throw Exception('TODO')
    }

    public init() {
        throw Exception('TODO')
    }

    public init(ws_row: Int16, ws_col: Int16) {
        throw Exception('TODO')
    }

    // Methods End
}

open class Termios {
    // Fields Begin
    static var SIZEOF: Int64 = throw Exception('TODO')
    var c_iflag: Int64 = throw Exception('TODO')
    var c_oflag: Int64 = throw Exception('TODO')
    var c_cflag: Int64 = throw Exception('TODO')
    var c_lflag: Int64 = throw Exception('TODO')
    var c_cc: Array<Byte> = throw Exception('TODO')
    var c_ispeed: Int64 = throw Exception('TODO')
    var c_ospeed: Int64 = throw Exception('TODO')
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    private static func init(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

