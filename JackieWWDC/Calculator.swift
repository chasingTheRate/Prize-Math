//
//  Calculator.swift
//  JackieMath2
//
//  Created by Mark Eaton on 4/15/15.
//  Copyright (c) 2015 Eaton Productions. All rights reserved.
//

import Foundation
import UIKit

class Calculator {
    
    var firstNum: Int = 0
    var secondNum: Int = 0
    var answerText: String = ""
    var operatorText: CalcOperator = .Add
    var operatorArray = [CalcOperator]()
    var negNumAllowed: Bool = false
    var shmqCorrectSwitch: Bool = false
    //var equation: String = ""
    var answer: Bool = false
    var calcObjs: [CalcObj] = []
    var numberOfTerms: Int = 0
    
    var randomTermOn: Bool = false
    var randomTerm = 0
    
    var equation: [String] = []
    var equationAsString = ""
    var userInput = ""{
        didSet{
            updateEquation()
        }
    }
    
    var userInputStartingLocation = 0
    var userInputLength = 0
    
    
    let userDefault = NSUserDefaults.standardUserDefaults()
    
    var stats = Stats()

    enum CalcOperator{
        
        case Add
        case Subtract
        case Multiply
        case Divide
        
        func description() -> String{
            switch self {
            case .Add:
                return "+"
            case .Subtract:
                return "-"
            case .Multiply:
                return "×"
            case .Divide:
                return "÷"
            }
        }
        
    }
    
    func CalcStringConversion(sender: String) ->CalcOperator{
        switch sender {
            case "+":
                return .Add
            case "-":
                return .Subtract
            case "×":
                return .Multiply
            case "÷":
                return .Divide
            default:
                return .Add
        }
    }
    
    func newCalc(){
    
        equation.removeAll()
        
        for obj in calcObjs{
            if obj.locked{
                equation.append(obj.max.description)
            }else{
                equation.append(Int(arc4random_uniform(UInt32(obj.max - obj.min)) + UInt32(obj.min)).description)
            }
            
            if obj != calcObjs.last{
                if obj.op == "s" {
                    equation.append(determineOperator().description())
                }else{
                    equation.append(obj.op)
                }
            }
        }
        
        print(equationAsString)
        
        let equationAnswer = calculateAnswer()
        equation.append("=")
        equation.append(equationAnswer)
        
        //Selected Random Term
        
        if randomTermOn{
            randomTerm = Int(arc4random_uniform(UInt32(calcObjs.count + 1)) * 2)
        }else{
            randomTerm = equation.count - 1
        }
        
        //Clear User Input
        userInput = ""
        
        updateEquation()
        updateUserInputLocationAndLength()
    }
    
    func determineOperator() -> CalcOperator {
        
        let randomNum = Int(arc4random_uniform(UInt32(operatorArray.count)))
        
        if operatorArray.count == 0 {
            
            return CalcOperator.Add
            
        } else {
            
            return operatorArray[randomNum]
        }
    }
    
    func calculateAnswer() -> String{
        
        var localEquation = equation
        print(localEquation)
        
        var value: Int
        var i = 1
        
        //Process Multiplication & Division
        
        while i <= localEquation.count-1{
            switch localEquation[i]{
            case "×", "÷":
                if localEquation[i] == "×" {
                    value = Int(localEquation[i-1])! * Int(localEquation[i+1])!
                }else{
                    value = Int(localEquation[i-1])! / Int(localEquation[i+1])!
                }
                localEquation.removeAtIndex(i-1)
                localEquation.removeAtIndex(i-1)
                localEquation.removeAtIndex(i-1)
                localEquation.insert(value.description, atIndex: i-1)
                i = i - 1
            default:
                i += 1
            }
        }
        
        //Process Addition & Subtraction
        
        i = 1
        
        while i <= localEquation.count-1{
            switch localEquation[i]{
            case "+", "-":
                if localEquation[i] == "+" {
                    value = Int(localEquation[i-1])! + Int(localEquation[i+1])!
                }else{
                    value = Int(localEquation[i-1])! - Int(localEquation[i+1])!
                }
                localEquation.removeAtIndex(i-1)
                localEquation.removeAtIndex(i-1)
                localEquation.removeAtIndex(i-1)
                localEquation.insert(value.description, atIndex: i-1)
                i = i - 1
            default:
                i += 1
            }
        }
    
        return localEquation[0]
    }
    
    func updateEquation() {
        
        var str = ""
        
        for i in 0..<equation.count{
            
            //Define String to Write to Equation
            if i == randomTerm{
                if userInput == "" {
                    str = "\u{200c}    \u{200c}"
                }else{
                    str = userInput
                }
            }else{
                str = equation[i]
            }
            
            if i == 0{
                equationAsString = str
            }else{
                equationAsString += " " + str
            }
        }
        
        updateUserInputLocationAndLength()
    }
    

    func checkAnswer() -> Bool {
        
        if userInput == equation[randomTerm]{
            stats.correct()
            return true
        }else{
            return false
        }
    }
    
    func updateUserInputLocationAndLength(){
        
        var loc = 0
        var i = 0
        var length: Int
        
        
        while i < randomTerm{

            loc = loc + (equation[i].characters.count + 1) // +1 added to account for blank spaces
            i+=1
        }
        
        if userInput == ""{
            length = 2
        }else{
            length = userInput.characters.count
        }
        
        userInputStartingLocation = loc
        userInputLength = length
    }
    
}

class CalcObj: NSObject, NSCoding{
    var id: Int
    var min: Int
    var max: Int
    var locked: Bool
    var op: String
    
    init(id: Int, min: Int, max: Int, locked: Bool, op: String){
        self.id = id
        self.min = min
        self.max = max
        self.locked = locked
        self.op = op
    }
    
    required init (coder aDecoder: NSCoder) {
        self.min = aDecoder.decodeObjectForKey("min") as! Int
        self.max = aDecoder.decodeObjectForKey("max") as! Int
        self.locked = aDecoder.decodeObjectForKey("locked") as! Bool
        self.op = aDecoder.decodeObjectForKey("op") as! String
        self.id = aDecoder.decodeObjectForKey("id") as! Int
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(min, forKey:"min")
        aCoder.encodeObject(max, forKey:"max")
        aCoder.encodeObject(locked, forKey:"locked")
        aCoder.encodeObject(op, forKey:"op")
        aCoder.encodeObject(id, forKey:"id")
    }
}
