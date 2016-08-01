import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    @IBOutlet weak var descriptionDisplay: UILabel!

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
        displayDescription()
    }

    @IBAction func touchDecimal(sender: UIButton) {
        if (!brain.decimalActive) {
            touchDigit(sender)
            brain.decimalActive = true
        }
        displayDescription()
    }

    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.value = display.text!
        }
        userIsInTheMiddleOfTyping = false
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
        }
        displayDescription()
        display.text = brain.value
    }

    private func displayDescription() {
        descriptionDisplay.text = brain.descriptionForDisplay
    }
}