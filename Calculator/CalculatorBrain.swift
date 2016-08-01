import Foundation

class CalculatorBrain {

    private var accumulator = 0.0
    private var pending: PendingOperation?

    var description = " "
    var operationsInProcess = false
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
            case .UnaryOperation(let function):
                description += "\(symbol)\(accumulator)"
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingOperation(binaryFunction: function, firstOperand: accumulator)
                description += "\(!operationsInProcess ? "\(accumulator)" : "")\(symbol)"
            case .Equals:
                executePendingBinaryOperation()
            case .Clear:
                pending = nil
                decimalActive = false
                description = " "
                accumulator = 0.0
                operationsInProcess = false
                return
            }
            operationsInProcess = true
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
            description += "\(accumulator)"
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
}
