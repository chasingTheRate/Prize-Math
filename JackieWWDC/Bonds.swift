//
//  Bonds.swift
//  Prize Math
//
//  Created by Mark Eaton on 3/8/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import Foundation

class Bonds{
    
    var minValue: Int
    var maxValue: Int
    
    var wholeBubble: Int?
    var firstPartBubble: Int?
    var secondPartBubble: Int?
    
    var activeBubble: Int?
    
    var answer = ""
    
    let stats = Stats()
    
    init(min: Int, max: Int){
        self.minValue = min
        self.maxValue = max
    }
    
    func newBond(){
       
        //Pick random bubble for active bubble
        activeBubble = Int(arc4random_uniform(UInt32(3) - UInt32(0)) + UInt32(0))
        
        wholeBubble = Int(arc4random_uniform(UInt32(maxValue) - UInt32(minValue)) + UInt32(minValue))
        
        print(wholeBubble)
        firstPartBubble = Int(arc4random_uniform(UInt32(wholeBubble!)))
        
        secondPartBubble = wholeBubble! - firstPartBubble!
    }
    
    func checkAnswer() -> Bool{
        
        var valueToCompare = 0
        
        switch activeBubble!{
        case 0:
            valueToCompare = wholeBubble!
        case 1:
            valueToCompare = firstPartBubble!
        case 2:
            valueToCompare = secondPartBubble!
        default:
            return false
        }
        
        if Int(answer) == valueToCompare{
            stats.correct()
            return true
        }else{
            stats.wrong()
            return false
        }
    }
}