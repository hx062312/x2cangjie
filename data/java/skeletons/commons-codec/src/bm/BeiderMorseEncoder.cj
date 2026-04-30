// Package: commons_codec.bm
package commons_codec.bm

// Imports Begin
// Imports End

open class BeiderMorseEncoder <: StringEncoder {
    // Fields Begin
    var engine: Any = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public open func encode(source: Any): Any {
        throw Exception('TODO')
    }

    public open func encode(source: String): String {
        throw Exception('TODO')
    }

    public func getNameType(): Any {
        throw Exception('TODO')
    }

    public func getRuleType(): Any {
        throw Exception('TODO')
    }

    public func isConcat(): Bool {
        throw Exception('TODO')
    }

    public func setConcat(concat: Bool): Unit {
        throw Exception('TODO')
    }

    public func setNameType(nameType: Any): Unit {
        throw Exception('TODO')
    }

    public func setRuleType(ruleType: Any): Unit {
        throw Exception('TODO')
    }

    public func setMaxPhonemes(maxPhonemes: Int64): Unit {
        throw Exception('TODO')
    }

    // Methods End
}

