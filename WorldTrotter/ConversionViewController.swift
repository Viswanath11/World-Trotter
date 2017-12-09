//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Viswanath Subramani S S on 06/10/17.
//  Copyright © 2017 BNRGuide. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateCelsiusLabel()
		//print("Loaded ConversionViewController's View!")
	}
	
	func getRandomColor() -> UIColor{
		let randomRed:CGFloat = CGFloat(drand48())
		let randomGreen:CGFloat = CGFloat(drand48())
		let randomBlue:CGFloat = CGFloat(drand48())
		return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)

	}
	
	func getTodaysHour() -> Int {
		let date = Date()
		let calendar = Calendar.current
		let components = calendar.dateComponents(in: .current, from: date)
		if let hour = components.hour { return hour }
		else { return 0 }
	}
	
	override func viewWillAppear(_ animated: Bool) {
		//fixing random background color for the view
		//self.view.backgroundColor = getRandomColor()
		
		//fixing light/dark mode in accordance to user's local time! - My first implementation of localization
		let t = getTodaysHour()
		if t > 18 { self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)  }
		else { self.view.backgroundColor = UIColor.lightGray
		}
		
	}
	//Internationalization - Attempt to enter multiple decimal places in any specific region.
	func textField(_ textField: UITextField,
	                  shouldChangeCharactersIn range: NSRange,
	                  replacementString string: String) -> Bool {
		
//		let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
//		let replacementTextHasDecimalSeparator = string.range(of: ".")
//		
		let currentLocale = Locale.current
		let decimalSeparator = currentLocale.decimalSeparator ?? "."
		
		let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
		let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
		
		//It returns false and rejects the text if it finds the condition to be valid. “Logically, if the existing string has a decimal separator and the replacement string has a decimal separator, the change should be rejected."
		if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
			return false
		} else {
			return true
		}
	}
	
	//“Attempt to enter multiple decimal separators; the application will reject the second decimal separator that you enter.”
	//return NO (false) to not change text (means, to not accept recent user input)
	//func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
		
		// Get current string as `NSString`
	//	guard let existingString = textField.text as NSString? else { return false }
		//  In order to prevent two decimal separators (such as "1.2.3"), you check if both the existing string and the replacement string contain a period. But this prevents the replacement of – for example – "1.2" by "3.4" with copy/paste. To handle that correctly, you have to build the new string and check that:
		// Viswanath's Inference - here we are just creating a 'newString' by replacing existingString with replacementString called 'string' only on particular range where characters need to be replaced. After replacing we check if the newString has a valid number format witht the help of NumberFormatter
	//	let newString = existingString.replacingCharacters(in: range, with: string)
		// Check for empty result ...
	//	if newString.isEmpty {
	//		return true
	//	}
		// ... or valid number:
	//	let format = NumberFormatter()
	//	format.numberStyle = .decimal
	//	return format.number(from: newString) != nil

		
		//Have found some way around using MeasurementFormatter but makes no difference - no improvements with including -1.52 or  -0.34 , -345
//				if let ns = Double(newString) {
//			return Measurement(value: ns, unit: UnitTemperature.fahrenheit) != nil
//		}
//		return false
		
	//}
	
	
	@IBOutlet var celsiusLabel: UILabel!
	@IBOutlet var textField: UITextField!
	
	//“Here you are using a closure to instantiate the number formatter. You are creating a NumberFormatter with the .decimal style and configuring it to display no more than one fractional digit.”
	let  numberFormatter: NumberFormatter = {
		let nf=NumberFormatter()
		nf.numberStyle = .decimal
		nf.minimumFractionDigits = 0
		nf.maximumFractionDigits = 1
		return nf
	}()
	//implemented usage of UnitTemperature class and its stored properties (custom ones can also be included via extensions)
	var farenheitDegree: Measurement<UnitTemperature>? {
		didSet {
			updateCelsiusLabel()
		}
	}
	
	var celsiusDegree: Measurement<UnitTemperature>? {
		if let farenheitDegree = farenheitDegree {
			return farenheitDegree.converted(to: .celsius)
		} else {
			return nil
		}
		
	}
	
	@IBAction func farenheitTextChanged(_ textField: UITextField!) {
		if let text = textField.text, let num = numberFormatter.number(from: text) {
			farenheitDegree = Measurement(value: num.doubleValue, unit: .fahrenheit)
		} else {
			farenheitDegree = nil
		}
	}
	
	@IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer){
		textField.resignFirstResponder()
	}
	
	func updateCelsiusLabel() {
		if let celsiusDegree = celsiusDegree {
			celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusDegree.value))
		} else {
			celsiusLabel.text = "? ? ?"
		}
	}
}


