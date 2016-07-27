import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!

    private var userIsInTheMiddleOfTyping = false
    private var brain = CalculatorBrain()

    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyDisplayed = display.text!
            display.text = textCurrentlyDisplayed + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }

    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.value = display.text!
        }
        userIsInTheMiddleOfTyping = false
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
        }
        display.text = brain.value
    }
}