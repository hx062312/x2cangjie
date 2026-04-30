// Package: commons_codec.language
package commons_codec.language

// Imports Begin
// Imports End

open class ColognePhonetic <: StringEncoder {
    // Fields Begin
    static let AEIJOUY: Array<Rune> = throw Exception('TODO')
    static let CSZ: Array<Rune> = throw Exception('TODO')
    static let FPVW: Array<Rune> = throw Exception('TODO')
    static let GKQ: Array<Rune> = throw Exception('TODO')
    static let CKQ: Array<Rune> = throw Exception('TODO')
    static let AHKLOQRUX: Array<Rune> = throw Exception('TODO')
    static let SZ: Array<Rune> = throw Exception('TODO')
    static let AHKOQUX: Array<Rune> = throw Exception('TODO')
    static let DTX: Array<Rune> = throw Exception('TODO')
    static let CHAR_IGNORE: Rune = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private static func arrayContains(arr: Array<Rune>, key: Rune): Bool {
        throw Exception('TODO')
    }

    public func colognePhonetic(text: String): String {
        throw Exception('TODO')
    }

    public open func encode(object: Any): Any {
        throw Exception('TODO')
    }

    public open func encode(text: String): String {
        throw Exception('TODO')
    }

    public func isEncodeEqual(text1: String, text2: String): Bool {
        throw Exception('TODO')
    }

    private func preprocess(text: String): Array<Rune> {
        throw Exception('TODO')
    }

    // Methods End
}

abstract open class CologneBuffer {
    // Fields Begin
    let data: Array<Rune> = throw Exception('TODO')
    var length: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(data: Array<Rune>) {
        throw Exception('TODO')
    }

    public init(buffSize: Int64) {
        throw Exception('TODO')
    }

    protected func copyData(start: Int64, length: Int64): Array<Rune> {
        throw Exception('TODO')
    }

    public func length(): Int64 {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    public func isEmpty(): Bool {
        throw Exception('TODO')
    }

    // Methods End
}

open class CologneOutputBuffer <: CologneBuffer {
    // Fields Begin
    var lastCode: Rune = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(buffSize: Int64) {
        throw Exception('TODO')
    }

    public func put(code: Rune): Unit {
        throw Exception('TODO')
    }

    protected func copyData(start: Int64, length: Int64): Array<Rune> {
        throw Exception('TODO')
    }

    // Methods End
}

open class CologneInputBuffer <: CologneBuffer {
    // Fields Begin
    // Fields End

    // Methods Begin
    public init(data: Array<Rune>) {
        throw Exception('TODO')
    }

    protected func copyData(start: Int64, length: Int64): Array<Rune> {
        throw Exception('TODO')
    }

    public func getNextChar(): Rune {
        throw Exception('TODO')
    }

    protected func getNextPos(): Int64 {
        throw Exception('TODO')
    }

    public func removeNext(): Rune {
        throw Exception('TODO')
    }

    // Methods End
}

