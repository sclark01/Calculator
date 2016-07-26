import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfTyping = false

    @IBAction func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyDisplayed = display!.text!
            display!.text = textCurrentlyDisplayed + digit
        } else {
            display!.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }

    @IBAction func performOperation(sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        if let mathSymbol = sender.currentTitle {
            if mathSymbol == "pi" {
                display.text = "\(M_PI)"
            }
        }
    }
}