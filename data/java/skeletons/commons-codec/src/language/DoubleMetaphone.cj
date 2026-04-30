// Package: commons_codec.language
package commons_codec.language

// Imports Begin
// Imports End

open class DoubleMetaphone <: StringEncoder {
    // Fields Begin
    static let VOWELS: String = throw Exception('TODO')
    static let SILENT_START: Array<String> = throw Exception('TODO')
    static let L_R_N_M_B_H_F_V_W_SPACE: Array<String> = throw Exception('TODO')
    static let ES_EP_EB_EL_EY_IB_IL_IN_IE_EI_ER: Array<String> = throw Exception('TODO')
    static let L_T_K_S_N_M_B_Z: Array<String> = throw Exception('TODO')
    var maxCodeLen: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init() {
        throw Exception('TODO')
    }

    public open func doubleMetaphone(value: String): String {
        throw Exception('TODO')
    }

    public open func doubleMetaphone(value: String, alternate: Bool): String {
        throw Exception('TODO')
    }

    public open func encode(obj: Any): Any {
        throw Exception('TODO')
    }

    public open func encode(value: String): String {
        throw Exception('TODO')
    }

    public open func isDoubleMetaphoneEqual(value1: String, value2: String): Bool {
        throw Exception('TODO')
    }

    public open func isDoubleMetaphoneEqual(value1: String, value2: String, alternate: Bool): Bool {
        throw Exception('TODO')
    }

    public func getMaxCodeLen(): Int64 {
        throw Exception('TODO')
    }

    public func setMaxCodeLen(maxCodeLen: Int64): Unit {
        throw Exception('TODO')
    }

    private func handleAEIOUY(result: Any, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private func handleC(value: String, result: Any, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private func handleCC(value: String, result: Any, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private func handleCH(value: String, result: Any, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private func handleD(value: String, result: Any, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private func handleG(value: String, result: Any, index: Int64, slavoGermanic: Bool): Int64 {
        throw Exception('TODO')
    }

    private func handleGH(value: String, result: Any, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private func handleH(value: String, result: Any, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private func handleJ(value: String, result: Any, index: Int64, slavoGermanic: Bool): Int64 {
        throw Exception('TODO')
    }

    private func handleL(value: String, result: Any, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private func handleP(value: String, result: Any, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private func handleR(value: String, result: Any, index: Int64, slavoGermanic: Bool): Int64 {
        throw Exception('TODO')
    }

    private func handleS(value: String, result: Any, index: Int64, slavoGermanic: Bool): Int64 {
        throw Exception('TODO')
    }

    private func handleSC(value: String, result: Any, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private func handleT(value: String, result: Any, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private func handleW(value: String, result: Any, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private func handleX(value: String, result: Any, index: Int64): Int64 {
        throw Exception('TODO')
    }

    private func handleZ(value: String, result: Any, index: Int64, slavoGermanic: Bool): Int64 {
        throw Exception('TODO')
    }

    private func conditionC0(value: String, index: Int64): Bool {
        throw Exception('TODO')
    }

    private func conditionCH0(value: String, index: Int64): Bool {
        throw Exception('TODO')
    }

    private func conditionCH1(value: String, index: Int64): Bool {
        throw Exception('TODO')
    }

    private func conditionL0(value: String, index: Int64): Bool {
        throw Exception('TODO')
    }

    private func conditionM0(value: String, index: Int64): Bool {
        throw Exception('TODO')
    }

    private func isSlavoGermanic(value: String): Bool {
        throw Exception('TODO')
    }

    private func isVowel(ch: Rune): Bool {
        throw Exception('TODO')
    }

    private func isSilentStart(value: String): Bool {
        throw Exception('TODO')
    }

    private func cleanInput(input: String): String {
        throw Exception('TODO')
    }

    protected func charAt(value: String, index: Int64): Rune {
        throw Exception('TODO')
    }

    protected static func contains(value: String, start: Int64, length: Int64): Bool {
        throw Exception('TODO')
    }

    // Methods End
}

open class DoubleMetaphoneResult {
    // Fields Begin
    let primary: Any = throw Exception('TODO')
    let alternate: Any = throw Exception('TODO')
    let maxLength: Int64 = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public init(maxLength: Int64) {
        throw Exception('TODO')
    }

    public open func append(value: Rune): Unit {
        throw Exception('TODO')
    }

    public open func append(primary: Rune, alternate: Rune): Unit {
        throw Exception('TODO')
    }

    public open func appendPrimary(value: Rune): Unit {
        throw Exception('TODO')
    }

    public open func appendAlternate(value: Rune): Unit {
        throw Exception('TODO')
    }

    public open func append(value: String): Unit {
        throw Exception('TODO')
    }

    public open func append(primary: String, alternate: String): Unit {
        throw Exception('TODO')
    }

    public open func appendPrimary(value: String): Unit {
        throw Exception('TODO')
    }

    public open func appendAlternate(value: String): Unit {
        throw Exception('TODO')
    }

    public func getPrimary(): String {
        throw Exception('TODO')
    }

    public func getAlternate(): String {
        throw Exception('TODO')
    }

    public func isComplete(): Bool {
        throw Exception('TODO')
    }

    // Methods End
}

