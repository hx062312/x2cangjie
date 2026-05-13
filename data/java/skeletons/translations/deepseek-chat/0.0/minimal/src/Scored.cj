// Package: minimal
package minimal

// Imports Begin

// Imports End

open class Scored {
    // Fields Begin
    var name: String = ""  // Already translated, compilation failed
    var value: Int64 = 0
    var active: Bool = false
    // Fields End

    // Methods Begin
    public init(name: String, value: Int64, active: Bool) {
                this.name = name
        this.value = value
        this.active = active
    }

    public open func getName(): String {
                return this.name
    }

    public open func getValue(): Int64 {
                return this.value
    }

    public open func isActive(): Bool {
                return this.active
    }

    // Methods End
}

