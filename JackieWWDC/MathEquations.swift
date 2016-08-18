//
//  MathEquations.swift
//  Prize Math
//
//  Created by Mark Eaton on 3/8/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import Foundation

class MathEquations{
    
    let numberOfTypes = 4
    
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
    }
    
    func convertIntToType(sender: Int) -> type?{
        switch sender{
        case 0:
            return .counting
        case 1:
            return .basic
        case 2:
            return .bonds
        case 3:
            return .fractions
        default:
            return nil
        }
    }
    
}