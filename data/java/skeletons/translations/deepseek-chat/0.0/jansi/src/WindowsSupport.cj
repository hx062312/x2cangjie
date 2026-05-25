// Package: jansi
package jansi

// Imports Begin

// Imports End

public open class WindowsSupport {
    // Fields Begin
    // Fields End

    // Methods Begin
    public static func getLastErrorMessage(): String {
                return Kernel32.getLastErrorMessage()
    }

    public static func getErrorMessage(errorCode: Int64): String {
                return Kernel32.getErrorMessage(errorCode)
    }

    // Methods End
}

