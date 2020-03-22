//
//  ViewController.swift
//  Calculator
//
//  Created by Björn Kaczmarek on 19/3/20.
//  Copyright © 2020 Björn Kaczmarek. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!

    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var operationButtons: [UIButton]!
    @IBOutlet var topButtons: [UIButton]!
    
    var userIsPerformingOperation = true
    var subTotal: Double? = nil
    var userFinishedOperation = false
    
    enum operatorType {
        case plus
        case subtract
        case multiply
        case divide
    }
    
    var lastOperator: operatorType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        display.text = "0"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // react to light / dark appearance of UI
        let userInterFaceStyle = traitCollection.userInterfaceStyle
        
        switch userInterFaceStyle {
        case .light:
            // light appearance is active
            view.backgroundColor = .white
            display.textColor = .black
            
            // appearance of numberbuttons
            for button in numberButtons {
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = UIColor(red: (230/255), green: (230/255), blue: (230/255), alpha: 1)
            }
            
            // appearance of operationbuttons
            for button in operationButtons {
                button.backgroundColor = UIColor(red: (35/255), green: (35/255), blue: (250/255), alpha: 1)
            }
            
        case .dark:
            // dark appearance is active
            view.backgroundColor = .black
            display.textColor = .white
        default:
            return
        }
    }
    
    @IBAction func touchedDigit(_ sender: UIButton) {
        // user touched a number between 0-9
        if userIsPerformingOperation {
            // if user touched an operation clear display for new number
            display.text = sender.currentTitle
            userIsPerformingOperation = false
        } else {
            // if user didn't touch operation add number to current display
            let textCurrentlyInDisplay = display.text
            if let digit = sender.currentTitle {
            display.text = textCurrentlyInDisplay! + digit
            }
        }
    }
    
    @IBAction func touchedEqual(_ sender: UIButton) {
        // user touched equal operation
        var result: Double? = nil
        if let finOperator = lastOperator {
            switch finOperator {
            case .plus:
                result = subTotal! + Double(display.text!)!
            case .subtract:
                result = subTotal! - Double(display.text!)!
            case .multiply:
                result = subTotal! * Double(display.text!)!
            case .divide:
                result = subTotal! / Double(display.text!)!
            }
        }
        display.text = "\(result!)"
        subTotal = result
        userIsPerformingOperation = true
        userFinishedOperation = true
    }
    
    @IBAction func performCalculation(_ sender: UIButton) {
        // user touched + - x ÷ π etc.
        if let doubleEntry = Double(display.text!) {
            switch sender.currentTitle! {
            case "e":
                display.text = String(Darwin.M_E)
                subTotal = Darwin.M_E
                userIsPerformingOperation = true
            case "π":
                display.text = String(Double.pi)
                subTotal = Double.pi
                userIsPerformingOperation = true
            case "AC":
                display.text = ""
                subTotal = 0
                userIsPerformingOperation = false
                userFinishedOperation = false
            case "√":
                display.text = String(sqrt(doubleEntry))
                subTotal = sqrt(doubleEntry)
                userIsPerformingOperation = true
            case "+":
                performOperation(entry: doubleEntry, operation: "+")
                lastOperator = operatorType.plus
                userIsPerformingOperation = true
                display.text = "\(subTotal!)"
            case "-":
                performOperation(entry: doubleEntry, operation: "-")
                lastOperator = operatorType.subtract
                userIsPerformingOperation = true
                display.text = "\(subTotal!)"
            case "x":
                performOperation(entry: doubleEntry, operation: "x")
                lastOperator = operatorType.multiply
                userIsPerformingOperation = true
                display.text = "\(subTotal!)"
            case "÷":
                performOperation(entry: doubleEntry, operation: "÷")
                lastOperator = operatorType.divide
                userIsPerformingOperation = true
                display.text = "\(subTotal!)"
            default:
                display.text = ""
            }
        }
    }
    
    @IBAction func invertNumber(_ sender: UIButton) {
        // user touched ±
        if let number = Double(display.text!) {
            let invertedNumber = -number
            subTotal = invertedNumber
            display.text = "\(invertedNumber)"
        }
    }
    
    func performOperation(entry: Double, operation: String) {
        if userFinishedOperation {
            userFinishedOperation = false
        } else {
            switch operation {
            case "+":
                if let currentSubTotal = subTotal {
                    subTotal = entry + currentSubTotal
                } else {
                    subTotal = entry
                }
            case "-":
                if let currentSubTotal = subTotal {
                    subTotal = currentSubTotal - entry
                } else {
                    subTotal = entry
                }
            case "x":
                if let currentSubTotal = subTotal {
                    subTotal = entry * currentSubTotal
                } else {
                    subTotal = entry
                }
            case "÷":
                if let currentSubTotal = subTotal {
                    subTotal = entry / currentSubTotal
                } else {
                    subTotal = entry
                }
            default:
                return
            }
        }
    }
}

