import Foundation

struct PendingBinaryOperationInfo {
    let binaryFunction: (Double, Double) -> Double
    let firstOperand: Double
}