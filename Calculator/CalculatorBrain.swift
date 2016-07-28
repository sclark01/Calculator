import Foundation

class CalculatorBrain {

    private var accumulator = 0.0
    private var pending: PendingOperation?

    var decimalActive = false

    private let operations: Dictionary<String, Operation> = [
        "pi": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "+/-": Operation.UnaryOperation({-$0}),
        "1/x": Operation.UnaryOperation({1.0/$0}),
        "%": Operation.UnaryOperation({$0/100.0}),
        "x": Operation.BinaryOperation(*),
        "/": Operation.BinaryOperation(/),
        "+": Operation.BinaryOperation(+),
        "-": Operation.BinaryOperation(-),
        "mod": Operation.BinaryOperation(%),
        "=": Operation.Equals,
        "C": Operation.Clear
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
                break
            case .Clear:
                pending = nil
                decimalActive = false
                accumulator = 0.0
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
        decimalActive = false
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
}
