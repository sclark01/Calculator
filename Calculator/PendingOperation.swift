import Foundation

struct PendingOperation {
    let binaryFunction: (Double, Double) -> Double
    let firstOperand: Double
}