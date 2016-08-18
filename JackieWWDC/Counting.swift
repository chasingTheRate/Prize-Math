//
//  Counting.swift
//  Prize Math
//
//  Created by Mark Eaton on 3/2/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import Foundation

class Counting{
    
    var count: Int = 0
    var maxValue: Int
    var minValue: Int
    var answer = ""
    
    let stats = Stats()
    
    init(max: Int, min: Int){
        self.maxValue = max
        self.minValue = min
    }
    
    func newCount(){
        
        //Clear Answer
        answer = ""
        
        count = Int(arc4random_uniform(UInt32(maxValue) - UInt32(minValue)) + UInt32(minValue))
    }
    
    func checkAnswer() -> Bool{
        
        if Int(answer) == count{
            stats.correct()
            return true
        }else{
            stats.wrong()
            return false
        }
    }
    
}