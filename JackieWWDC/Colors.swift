//
//  Colors.swift
//  Prize Math
//
//  Created by Mark Eaton on 1/30/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import Foundation
import UIKit

class Colors{
    
    var primaryColor: [Int: UIColor] = [0: UIColor(red: 1.0, green: 102/255, blue: 102/255, alpha: 1.0)]
    
    var secondaryColor: [Int: UIColor] = [0: UIColor(red: 102/255, green: 204/255, blue: 1.0, alpha: 1.0)]
    
    var backroundColor: [Int: UIColor] = [0: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
    
    var correctColor = UIColor(red: 0, green: 255/255, blue: 128/255, alpha: 1.0)
    
    var nightModeViewCell = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1.0)
    var nightModeViewCellOff = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    var nightModeSection = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    var nightModeSectionOff = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
    
    var nightModeSectionText = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var nightModeSectionTextOff = UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 1.0)
    
    var nightModeOff = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    var nightModeDetailText = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var nightModeDetailTextOff = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
    
    var nightModePlaceHolder = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.5)
    var nightModePlaceHolderOff = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.5)
}