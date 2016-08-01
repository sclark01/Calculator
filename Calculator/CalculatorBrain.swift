import Foundation

class CalculatorBrain {

    private var accumulator = 0.0
    private var pending: PendingOperation?
    private var pendingUnaryOperation = false
    private var operationsInProcess = false

    var description = ""
    var descriptionForDisplay: String {
        get {
            return description + "\(isPartialResult ? "..." : "=")"
        }
    }

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
                pendingUnaryOperation = true
                formatDescriptionForUnaryOperation(symbol)
                accumulator = function(accumulator)
                description += ")"
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingOperation(binaryFunction: function, firstOperand: accumulator)
                description += "\(!operationsInProcess ? "\(accumulator)" : "")\(symbol)"
            case .Equals:
                executePendingBinaryOperation()
            case .Clear:
                pending = nil
                decimalActive = false
                operationsInProcess = false
                pendingUnaryOperation = false
                description = ""
                accumulator = 0.0
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

    var isPartialResult: Bool {
        return pending != nil
    }

    private func formatDescriptionForUnaryOperation(symbol: String) {
        if (isPartialResult) {
            description += "\(symbol)(\(accumulator)"
        } else {
            description = "\(symbol)(\(description.isEmpty ? "\(accumulator)" : description)"
        }
    }

    private func executePendingBinaryOperation() {
        decimalActive = false
        if isPartialResult {
            if !pendingUnaryOperation { description += "\(accumulator)" }
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
        pendingUnaryOperation = false
    }
}
