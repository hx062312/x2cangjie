// Package: JavaFeatureTest
package JavaFeatureTest

// Imports Begin
// Imports End

@Test
open class CalculatorTest {
    // Fields Begin
    // Fields End

    // Methods Begin
    public open func testConstructorOverloadNoArgs(): Unit {
                let calc = Calculator()
        @Expect(0, calc.getResult())
        @Expect("Default", calc.getName())
    }

    public open func testConstructorOverloadOneArg(): Unit {
                let calc = Calculator(100)
        @Expect(100, calc.getResult())
        @Expect("Basic", calc.getName())
    }

    public open func testConstructorOverloadTwoArgs(): Unit {
                let calc = Calculator(200, "Custom")
        @Expect(calc.getResult(), 200)
        @Expect(calc.getName(), "Custom")
    }

    public open func testMethodOverloadInt(): Unit {
                let calc = Calculator()
        @Expect(30, calc.add(10, 20))
    }

    public open func testMethodOverloadDouble(): Unit {
                let calc = Calculator()
        @Expect(calc.add(10.5, 20.0), 30.5, 0.001)
    }

    public open func testMethodOverloadThreeArgs(): Unit {
                let calc = Calculator()
        @Expect(60, calc.add(10, 20, 30))
    }

    public open func testMethodOverloadString(): Unit {
                let calc = Calculator()
        @Expect("HelloWorld", calc.add("Hello", "World"))
    }

    // Methods End
}

