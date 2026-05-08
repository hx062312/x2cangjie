// Package: minimal
package minimal

// Imports Begin

// Imports End

open class AddDependency {
    // Fields Begin
    // Fields End

    // Methods Begin
    public static func normalizeLabel(label: String): String {
                return "tag:" + label
    }

    public static func computeDelta(currentValue: Int64, auditSize: Int64): Int64 {
        throw Exception('TODO')
    }

    public static func formatScore(name: String, value: Int64): String {
        throw Exception('TODO')
    }

    // Methods End
}

