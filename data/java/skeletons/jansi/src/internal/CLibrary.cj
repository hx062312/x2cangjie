// Package: jansi.internal
package jansi.internal

// Imports Begin
// Imports End

class CLibrary {
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

    public static func openpty(amaster: Array<Int64>, aslave: Array<Int64>, name: Array<Int8>, termios: Any, winsize: Any): Int64 {
        throw Exception('TODO')
    }

    public static func tcgetattr(filedes: Int64, termios: Any): Int64 {
        throw Exception('TODO')
    }

    public static func tcsetattr(filedes: Int64, optional_actions: Int64, termios: Any): Int64 {
        throw Exception('TODO')
    }

    // Methods End
}

class WinSize {
    // Fields Begin
    static var SIZEOF: Int64 = throw Exception('TODO')
    var ws_row: Int16 = throw Exception('TODO')
    var ws_col: Int16 = throw Exception('TODO')
    var ws_xpixel: Int16 = throw Exception('TODO')
    var ws_ypixel: Int16 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private static func init(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

class Termios {
    // Fields Begin
    static var SIZEOF: Int64 = throw Exception('TODO')
    var c_iflag: Int64 = throw Exception('TODO')
    var c_oflag: Int64 = throw Exception('TODO')
    var c_cflag: Int64 = throw Exception('TODO')
    var c_lflag: Int64 = throw Exception('TODO')
    var c_cc: Array<Int8> = throw Exception('TODO')
    var c_ispeed: Int64 = throw Exception('TODO')
    var c_ospeed: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private static func init(): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

