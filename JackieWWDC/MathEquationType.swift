//
//  MathEquationType.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/18/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import Foundation

import Foundation

class MathEquationType: NSObject, NSCoding {
    
    private let titleKey = "complicationTitle"
    private let actionKey = "complicationAction"
    private let imagePathKey = "complicationImagePath"
    private let typeKey = "MathEquationTypeKey"
    
    enum type{
        
        case counting
        case basic
        case bonds
        case fractions
        
        func rawValue() -> Int{
            switch self{
            case counting:
                return 0
            case basic:
                return 1
            case bonds:
                return 2
            case fractions:
                return 3
            }
        }
        
        func description() -> String{
            switch self{
            case .basic:
                return "basic"
            case .bonds:
                return "bonds"
            case .counting:
                return "counting"
            case .fractions:
                return "fractions"
            }
        }
        
        func title() ->String{
            switch self{
            case .basic:
                return "BASIC"
            case .bonds:
                return "BONDS"
            case .counting:
                return "COUNTING"
            case .fractions:
                return "FRACTIONS"
            }
        }

    }

    
    init(type: type){
        self.title = title
        self.action = action
        self.imagePath = imagePath
    }
    
    required init (coder aDecoder: NSCoder) {
        
        self.title = aDecoder.decodeObjectForKey(titleKey) as! String
        self.action = aDecoder.decodeObjectForKey(actionKey) as? String
        self.imagePath = aDecoder.decodeObjectForKey(imagePathKey) as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey:titleKey)
        aCoder.encodeObject(action, forKey:actionKey)
        aCoder.encodeObject(imagePath, forKey:imagePathKey)
    }
}

struct MathType{
    
    enum
}