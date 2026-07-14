// Package: jansi
package jansi

// Imports Begin

// Imports End

public open class CLibrary {
    // Fields Begin
    static let LOADED: Bool = throw Exception('TODO')
    static var STDOUT_FILENO: Int32 = throw Exception('TODO')
    static var STDERR_FILENO: Int32 = throw Exception('TODO')
    static var HAVE_ISATTY: Bool = throw Exception('TODO')
    static var HAVE_TTYNAME: Bool = throw Exception('TODO')
    static var TCSANOW: Int32 = throw Exception('TODO')
    static var TCSADRAIN: Int32 = throw Exception('TODO')
    static var TCSAFLUSH: Int32 = throw Exception('TODO')
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
    private static func init_(): Unit {
        throw Exception('TODO')
    }

    public static func isatty(fd: Int32): Int32 {
        throw Exception('TODO')
    }

    public static func ttyname(filedes: Int32): String {
        throw Exception('TODO')
    }

    public static func openpty(amaster: Array<Int32>, aslave: Array<Int32>, name: Array<Int8>, termios: CLibrary_Termios, winsize: CLibrary_WinSize): Int32 {
        throw Exception('TODO')
    }

    public static func tcgetattr(filedes: Int32, termios: CLibrary_Termios): Int32 {
        throw Exception('TODO')
    }

    public static func tcsetattr(filedes: Int32, optional_actions: Int32, termios: CLibrary_Termios): Int32 {
        throw Exception('TODO')
    }

    public static func ioctl(filedes: Int32, request: Int64, params: Array<Int32>): Int32 {
        throw Exception('TODO')
    }

    public static func ioctl(filedes: Int32, request: Int64, params: CLibrary_WinSize): Int32 {
                return 0
    }

    // Methods End
}

public open class CLibrary_WinSize {
    // Fields Begin
    static var SIZEOF: Int32 = throw Exception('TODO')
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
    private static func init_(): Unit {
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

public open class CLibrary_Termios {
    // Fields Begin
    static var SIZEOF: Int32 = throw Exception('TODO')
    var c_iflag: Int64 = throw Exception('TODO')
    var c_oflag: Int64 = throw Exception('TODO')
    var c_cflag: Int64 = throw Exception('TODO')
    var c_lflag: Int64 = throw Exception('TODO')
    var c_cc: Array<Int8> = throw Exception('TODO')
    var c_ispeed: Int64 = throw Exception('TODO')
    var c_ospeed: Int64 = throw Exception('TODO')
    // Fields End

    // Static Initializer Begin
    static init() {
        throw Exception('TODO')
    }

    // Static Initializer End

    // Methods Begin
    private static func init_(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

