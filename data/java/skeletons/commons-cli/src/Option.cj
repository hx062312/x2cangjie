// Package: commons_cli
package commons_cli

// Imports Begin
// Imports End

open class Option <: Cloneable & Serializable {
    // Fields Begin
    static let UNINITIALIZED: Int64 = throw Exception('TODO')
    static let UNLIMITED_VALUES: Int64 = throw Exception('TODO')
    static let serialVersionUID: Int64 = throw Exception('TODO')
    let option: String = throw Exception('TODO')
    var longOption: String = throw Exception('TODO')
    var argName: String = throw Exception('TODO')
    var description: String = throw Exception('TODO')
    var required: Bool = throw Exception('TODO')
    var optionalArg: Bool = throw Exception('TODO')
    var argCount: Int64 = throw Exception('TODO')
    var type: Type<Any> = throw Exception('TODO')
    var values: ArrayList<String> = throw Exception('TODO')
    var valuesep: Rune = throw Exception('TODO')
    // Fields End

    // Methods Begin
    public static func builder(): Any {
        throw Exception('TODO')
    }

    public static func builder(option: String): Any {
        throw Exception('TODO')
    }

    private init(builder: Any) {
        throw Exception('TODO')
    }

    public init(option: String, hasArg: Bool, description: String) {
        throw Exception('TODO')
    }

    public init(option: String, description: String) {
        throw Exception('TODO')
    }

    public init(option: String, longOption: String, hasArg: Bool, description: String) {
        throw Exception('TODO')
    }

    func acceptsArg(): Bool {
        throw Exception('TODO')
    }

    private func add(value: String): Unit {
        throw Exception('TODO')
    }

    public func addValue(value: String): Bool {
        throw Exception('TODO')
    }

    func addValueForProcessing(value: String): Unit {
        throw Exception('TODO')
    }

    func clearValues(): Unit {
        throw Exception('TODO')
    }

    public func clone(): Any {
        throw Exception('TODO')
    }

    public func equals(obj: Any): Bool {
        throw Exception('TODO')
    }

    public func getArgName(): String {
        throw Exception('TODO')
    }

    public func getArgs(): Int64 {
        throw Exception('TODO')
    }

    public func getDescription(): String {
        throw Exception('TODO')
    }

    public func getId(): Int64 {
        throw Exception('TODO')
    }

    func getKey(): String {
        throw Exception('TODO')
    }

    public func getLongOpt(): String {
        throw Exception('TODO')
    }

    public func getOpt(): String {
        throw Exception('TODO')
    }

    public func getType(): Any {
        throw Exception('TODO')
    }

    public open func getValue(): String {
        throw Exception('TODO')
    }

    public open func getValue(index: Int64): String {
        throw Exception('TODO')
    }

    public open func getValue(defaultValue: String): String {
        throw Exception('TODO')
    }

    public func getValues(): Array<String> {
        throw Exception('TODO')
    }

    public func getValueSeparator(): Rune {
        throw Exception('TODO')
    }

    public func getValuesList(): ArrayList<String> {
        throw Exception('TODO')
    }

    public func hasArg(): Bool {
        throw Exception('TODO')
    }

    public func hasArgName(): Bool {
        throw Exception('TODO')
    }

    public func hasArgs(): Bool {
        throw Exception('TODO')
    }

    public func hashCode(): Int64 {
        throw Exception('TODO')
    }

    public func hasLongOpt(): Bool {
        throw Exception('TODO')
    }

    private func hasNoValues(): Bool {
        throw Exception('TODO')
    }

    public func hasOptionalArg(): Bool {
        throw Exception('TODO')
    }

    public func hasValueSeparator(): Bool {
        throw Exception('TODO')
    }

    public func isRequired(): Bool {
        throw Exception('TODO')
    }

    private func processValue(value: String): Unit {
        throw Exception('TODO')
    }

    func requiresArg(): Bool {
        throw Exception('TODO')
    }

    public func setArgName(argName: String): Unit {
        throw Exception('TODO')
    }

    public func setArgs(num: Int64): Unit {
        throw Exception('TODO')
    }

    public func setDescription(description: String): Unit {
        throw Exception('TODO')
    }

    public func setLongOpt(longOpt: String): Unit {
        throw Exception('TODO')
    }

    public func setOptionalArg(optionalArg: Bool): Unit {
        throw Exception('TODO')
    }

    public func setRequired(required: Bool): Unit {
        throw Exception('TODO')
    }

    public open func setType(type: Type<Any>): Unit {
        throw Exception('TODO')
    }

    public open func setType(type: Any): Unit {
        throw Exception('TODO')
    }

    public func setValueSeparator(sep: Rune): Unit {
        throw Exception('TODO')
    }

    public func toString(): String {
        throw Exception('TODO')
    }

    // Methods End
}

class Builder {
    // Fields Begin
    var option: String = throw Exception('TODO')
    var description: String = throw Exception('TODO')
    var longOption: String = throw Exception('TODO')
    var argName: String = throw Exception('TODO')
    var required: Bool = throw Exception('TODO')
    var optionalArg: Bool = throw Exception('TODO')
    var argCount: Int64 = throw Exception('TODO')
    var type: Type<Any> = throw Exception('TODO')
    var valueSeparator: Rune = throw Exception('TODO')
    // Fields End

    // Methods Begin
    private init(option: String) {
        throw Exception('TODO')
    }

    public func argName(argName: String): Any {
        throw Exception('TODO')
    }

    public func build(): Option {
        throw Exception('TODO')
    }

    public func desc(description: String): Any {
        throw Exception('TODO')
    }

    public open func hasArg(): Any {
        throw Exception('TODO')
    }

    public open func hasArg(hasArg: Bool): Any {
        throw Exception('TODO')
    }

    public func hasArgs(): Any {
        throw Exception('TODO')
    }

    public func longOpt(longOpt: String): Any {
        throw Exception('TODO')
    }

    public func numberOfArgs(numberOfArgs: Int64): Any {
        throw Exception('TODO')
    }

    public func option(option: String): Any {
        throw Exception('TODO')
    }

    public func optionalArg(isOptional: Bool): Any {
        throw Exception('TODO')
    }

    public open func required(): Any {
        throw Exception('TODO')
    }

    public open func required(required: Bool): Any {
        throw Exception('TODO')
    }

    public func type(type: Type<Any>): Any {
        throw Exception('TODO')
    }

    public open func valueSeparator(): Any {
        throw Exception('TODO')
    }

    public open func valueSeparator(sep: Rune): Any {
        throw Exception('TODO')
    }

    // Methods End
}

