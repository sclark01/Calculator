import Foundation

class CalculatorBrain {

    private var accumulator = 0.0

    func setOperand(operand: Double) {
        accumulator = operand
    }

    private let operations: Dictionary<String, Operation> = [
        "pi": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "x": Operation.BinaryOperation(*),
        "/": Operation.BinaryOperation(/),
        "+": Operation.BinaryOperation(+),
        "-": Operation.BinaryOperation(-),
        "=": Operation.Equals
    ]

    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }

    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }

    private var pending: PendingBinaryOperationInfo?

    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
                case .Constant(let value):
                    accumulator = value
                    break
                case .UnaryOperation(let function):
                    accumulator = function(accumulator)
                    break
                case .BinaryOperation(let function):
                    executePendingBinaryOperation()
                    pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                    break
                case .Equals:
                    executePendingBinaryOperation()
            }
        }
    }

    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }

    var result: Double {
        get {
            return accumulator
        }
    }
}
