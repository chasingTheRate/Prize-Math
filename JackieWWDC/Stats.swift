//
//  Stats.swift
//  Prize Math
//
//  Created by Mark Eaton on 3/7/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import Foundation

class Stats
    
{
    var totalCount: Int = 0
    var totalCorrectCount: Int = 0
    var numCorrectInRow: Int = 0
    
    func correct()
    {
        numCorrectInRow += 1
        totalCount += 1
        totalCorrectCount += 1
    }
    
    func wrong()
    {
        totalCount += 1
        numCorrectInRow = 0
    }
}