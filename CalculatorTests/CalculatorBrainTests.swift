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

                it("should take the cosine of the accumulator") {
                    brain.performOperation("pi")
                    brain.performOperation("cos")

                    expect(brain.value) == "-1.0"
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

            }

        }
    }
}