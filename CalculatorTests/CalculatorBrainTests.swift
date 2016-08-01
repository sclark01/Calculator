import Foundation
import Quick
import Nimble

@testable import Calculator

class CalculatorBrainTests : QuickSpec {
    override func spec() {
        describe("perform operation") {

            var brain: CalculatorBrain!

            beforeEach {
                brain = CalculatorBrain()
                brain.value = "0.0"
            }

            describe("constants") {

                it("should not change the value for an unrecognized symbol"){
                    let startingValue = brain.value

                    brain.performOperation("someWierdSymbol")
                    let endingValue = brain.value

                    expect(startingValue) == endingValue
                }

                it("should set the value to be string pi when symbol is 'pi'") {
                    brain.performOperation("pi")

                    expect(brain.value) == "\(M_PI)"
                }

                it("should set the value to be string e when symbol is 'e'") {
                    brain.performOperation("e")

                    expect(brain.value) == "\(M_E)"
                }
            }

            describe("unary operations") {
                it("should take the square root of the accumulator") {
                    brain.value = "4"

                    brain.performOperation("√")

                    expect(brain.value) == "2.0"
                }

                it("should take the inverse of the value") {
                    brain.value = "4"

                    brain.performOperation("1/x")

                    expect(brain.value) == "0.25"
                }

                it("should change the sign of the value") {
                    brain.value = "4"

                    brain.performOperation("+/-")

                    expect(brain.value) == ("-4.0")
                }

                it("should make the value a percentage decimal") {
                    brain.value = "50"

                    brain.performOperation("%")

                    expect(brain.value) == "0.5"
                }
            }

            describe("binary operations") {
                it("should not change the value for first constant when multiplying") {
                    brain.value = "4"
                    brain.performOperation("x")

                    expect(brain.value) == "4.0"
                }

                it("should change the value to the second constant after multiply") {
                    brain.value = "4"
                    brain.performOperation("x")
                    brain.value = "3"
                    
                    expect(brain.value) == "3.0"
                }
                
                it("should change to the multiplied result when equals is called") {
                    brain.value = "4"
                    brain.performOperation("x")
                    brain.value = "3"
                    brain.performOperation("=")

                    expect(brain.value) == "12.0"
                }

                it("should change to the multiplied result when equals is called") {
                    brain.value = "4"
                    brain.performOperation("x")
                    brain.value = "3"
                    brain.performOperation("=")

                    expect(brain.value) == "12.0"
                }

                it("should change to the multiplied result when another operation is called") {
                    brain.value = "4"
                    brain.performOperation("x")
                    brain.value = "3"
                    brain.performOperation("+")

                    expect(brain.value) == "12.0"
                }

                it("should set the decimal active flag to false") {
                    brain.value = "4.5"
                    brain.decimalActive = true
                    brain.performOperation("+")

                    expect(brain.decimalActive).to(beFalse())
                }


                it("should take the mod of two values") {
                    brain.value = "5"

                    brain.performOperation("mod")
                    brain.value = "2"
                    brain.performOperation("=")

                    expect(brain.value) == "1.0"
                }

            }

            describe("clear") {
                it("should set the value back to 0") {
                    brain.value = "5.0"

                    brain.performOperation("C")

                    expect(brain.value) == "0.0"

                }

                it("should set decimal active flag to false") {
                    brain.value = "4.5"
                    brain.decimalActive = true

                    brain.performOperation("C")

                    expect(brain.decimalActive).to(beFalse())
                }

                it("should set the description to space") {
                    brain.description = "someDescription"
                    brain.performOperation("C")
                    expect(brain.description) == " "
                }
            }

            describe("description") {
                it("should accumulate all operators and operands") {
                    brain.value = "4"
                    brain.performOperation("+")
                    brain.value = "5"
                    brain.performOperation("=")

                    let expectedDesc = " 4.0+5.0"

                    expect(brain.description) == expectedDesc
                }

                it("should correctly describe multiple operations") {
                    brain.value = "5"
                    brain.performOperation("+")
                    brain.value = "3"
                    brain.performOperation("x")
                    brain.value = "4"
                    brain.performOperation("=")

                    let expectedDesc = " 5.0+3.0x4.0"

                    expect(brain.description) == expectedDesc
                }

            }
        }
    }
}