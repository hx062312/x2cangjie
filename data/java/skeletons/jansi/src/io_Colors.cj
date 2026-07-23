// Package: jansi
package jansi

// Imports Begin

// Imports End

public open class Colors {
    // Fields Begin
    static let epsilon: Float64 = throw Exception('TODO')
    static let kappa: Float64 = throw Exception('TODO')
    static let DEFAULT_COLORS_256: Array<Int32> = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func roundColor0(col: Int32, max: Int32): Int32 {
        throw Exception('TODO')
    }

    public static func roundRgbColor(r: Int32, g: Int32, b: Int32, max: Int32): Int32 {
        throw Exception('TODO')
    }

    private static func roundColor1(color: Int32, colors: Array<Int32>, max: Int32): Int32 {
        throw Exception('TODO')
    }

    private static func cie76(c1: Int32, c2: Int32): Float64 {
        throw Exception('TODO')
    }

    private static func scalar(c1: Array<Float64>, c2: Array<Float64>): Float64 {
        throw Exception('TODO')
    }

    private static func rgb(color: Int32): Array<Float64> {
        throw Exception('TODO')
    }

    private static func rgb2cielab0(color: Int32): Array<Float64> {
        throw Exception('TODO')
    }

    private static func rgb2cielab1(rgb: Array<Float64>): Array<Float64> {
        throw Exception('TODO')
    }

    private static func rgb2xyz(rgb: Array<Float64>): Array<Float64> {
        throw Exception('TODO')
    }

    private static func pivotRgb(n: Float64): Float64 {
        throw Exception('TODO')
    }

    private static func xyz2lab(xyz: Array<Float64>): Array<Float64> {
        throw Exception('TODO')
    }

    private static func pivotXyz(n: Float64): Float64 {
        throw Exception('TODO')
    }

    private static func sqr(n: Float64): Float64 {
        throw Exception('TODO')
    }

    // Methods End
}

