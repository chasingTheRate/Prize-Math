//
//  UserDefaults.swift
//  Prize Math
//
//  Created by Mark Eaton on 1/30/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import Foundation

class UserDefaults{
   
    let keyEquationArray: String = "keyEquationArray"
    
    enum key: String{
        
        //UI Settings
        
        case colorSelection = "colorSelection"
        
        //Main
        
        case prizesWon = "prizesWon"

        //Settings
        case selectedTypeSettings = "selectedTypeSettings"
        case selectedType = "selectedType" //NEW SHOULD REPLACE ^
        case selectedTheme = "selectedTheme"
        case calcObj = "calcObj"
        
        //Basic
        case switchAddition = "switchAddition"
        case switchSubtraction = "switchSubtraction"
        case switchMultiplication = "switchMultiplication"
        case switchDivider = "switchDivider"
        case numberOfTerms = "numberOfTerms"
        case randomTerm = "randomTerm"

        //Counting
        case minValue = "minValue"
        case maxValue = "maxValue"
        
        //Bonus Question Settings
        
        case setBonusQuestion = "setBonusQuestion"
        case triggerText = "triggerText"
        case timeText = "timeText"
        case timeSwitch = "timeSwitch"
        case setBonusLabel = "setBonusLabel"
        case numOfEquations = "numOfEquations"
        case bonusQuestionQty = "bonusQuestionQty"
        case passcodeOn = "passCodeOn"
        case bonusQuestions = "bonusQuestions"
        case selectedComplication = "selectedComplication"
        case selectedTypeBonus = "selectedTypeBonus"
        
        //PassCode
        
        case passcodeSet = "passCodeSet"
        case passcode = "passcode"
        
    }

}