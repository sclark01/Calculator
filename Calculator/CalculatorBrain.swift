import Foundation

class CalculatorBrain {

    private var accumulator = 0.0
    private var pending: PendingOperation?

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
                    pending = PendingOperation(binaryFunction: function, firstOperand: accumulator)
                    break
                case .Equals:
                    executePendingBinaryOperation()
            }
        }
    }

    var value: String {
        get {
            return "\(accumulator)"
        }
        set {
            accumulator = Double(newValue) ?? 0.0
        }
    }

    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
}
