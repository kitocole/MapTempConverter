//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Kaeny Ito-Cole on 2/23/16.
//  Copyright © 2016 Kaeny Ito-Cole. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    
    var fahrenheitValue: Double? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Double? {
        if let value = fahrenheitValue {
            return (value - 32) * (5/9)
        }
        else {
            return nil
        }
    }
    
    let numberFormatter: NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    } ()
    
    @IBOutlet var textField: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        let date = NSDate() //current date
        let calendar = NSCalendar.currentCalendar() //creates calendar
        let hour = calendar.component(.Hour, fromDate: date) //gets hour component int
        
        if(hour < 10) {
            view.backgroundColor = UIColor.blueColor()
        } else if(hour < 18){
            view.backgroundColor = UIColor.blueColor()
        } else {
            view.backgroundColor = UIColor.grayColor()
        }
        
        
    }
    
    @IBAction func fahrenheitFieldEditingChanged(textField: UITextField) {
        if let text = textField.text, value = Double(text) {
            fahrenheitValue = value
        }
        else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject){
        textField.resignFirstResponder()
    }
    
    func updateCelsiusLabel() {
        if let value = celsiusValue {
            celsiusLabel.text = numberFormatter.stringFromNumber(value)
        }
        else {
            celsiusLabel.text = "???"
        }
    }
    
    func textField(textField: UITextField,
            shouldChangeCharactersInRange range: NSRange,
            replacementString string: String) -> Bool {
            
        let existingTextHasDecimalSeparator = textField.text?.rangeOfString(".")
        let replacementTextHasDecimalSeparator = string.rangeOfString(".")
        let replacementTextHasAlphabet = string.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet())
        
        if existingTextHasDecimalSeparator != nil &&
            replacementTextHasDecimalSeparator != nil {
                
            return false
        }
        else if replacementTextHasAlphabet != nil {
            return false
        }
        else {
            return true
        }
    }
}
