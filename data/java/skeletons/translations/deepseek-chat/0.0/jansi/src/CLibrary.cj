// Package: jansi
package jansi

// Imports Begin

// Imports End

public open class CLibrary {
    // Fields Begin
    static let LOADED: Bool = true
    static var STDOUT_FILENO: Int64 = 1
    static var STDERR_FILENO: Int64 = 2
    static var HAVE_ISATTY: Bool = false
    static var HAVE_TTYNAME: Bool = false
    static var TCSANOW: Int64 = 0
    static var TCSADRAIN: Int64 = 0
    static var TCSAFLUSH: Int64 = 0
    static var TIOCGETA: Int64 = throw Exception('TODO')
    static var TIOCSETA: Int64 = throw Exception('TODO')
    static var TIOCGETD: Int64 = throw Exception('TODO')
    static var TIOCSETD: Int64 = throw Exception('TODO')
    static var TIOCGWINSZ: Int64 = 0
    static var TIOCSWINSZ: Int64 = 0
    // Fields End

    // Static Initializer Begin
    static init() {
                JansiLoader.initialize()
        init_()
    }

    // Static Initializer End

    // Methods Begin
    private static func init_(): Unit {
                // No-op, native method stub
    }

    public static func isatty(fd: Int64): Int64 {
                throw Exception("TODO")
    }

    public static func ttyname(filedes: Int64): String {
                throw Exception("TODO")
    }

    public static func openpty(amaster: Array<Int32>, aslave: Array<Int32>, name: Array<Byte>, termios: CLibrary_Termios, winsize: CLibrary_WinSize): Int64 {
                throw Exception('TODO')
    }

    public static func tcgetattr(filedes: Int64, termios: CLibrary_Termios): Int64 {
                throw Exception('TODO')
    }

    public static func tcsetattr(filedes: Int64, optional_actions: Int64, termios: CLibrary_Termios): Int64 {
                throw Exception("TODO")
    }

    public static func ioctl(filedes: Int64, request: Int64, params: CLibrary_WinSize): Int64 {
                throw Exception("TODO")
    }

    // Methods End
}

public open class CLibrary_WinSize {
    // Fields Begin
    static var SIZEOF: Int64 = 0
    var ws_row: Int16 = 0
    var ws_col: Int16 = 0
    var ws_xpixel: Int16 = 0
    var ws_ypixel: Int16 = 0
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

    public init(ws_row: Int16, ws_col: Int16) {
                this.ws_row = ws_row
        this.ws_col = ws_col
    }

    // Methods End

    protected init() {
        throw Exception('TODO')
    }
}

public open class CLibrary_Termios {
    // Fields Begin
    static var SIZEOF: Int64 = 0
    var c_iflag: Int64 = 0
    var c_oflag: Int64 = 0
    var c_cflag: Int64 = 0
    var c_lflag: Int64 = 0
    var c_cc: Array<Byte> = throw Exception('TODO')  // Already translated, compilation failed
    var c_ispeed: Int64 = 0
    var c_ospeed: Int64 = 0
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

