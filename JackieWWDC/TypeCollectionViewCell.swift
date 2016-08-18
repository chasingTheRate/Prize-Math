//
//  TypeCollectionViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 4/4/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var timer = NSTimer()
    var isAnimating = false
    var initialBorderColor: CGColor?
    var initialBorderWidth: CGFloat?
    var initialValuesSet = false
    
    func animate(){
        //Override
    }
    
    func startAnimation(){
        //Override
    }
    
    func endAnimation(){
        //Override
    }
    
    func didSelect(){
        
        if !initialValuesSet{
            initialValuesSet = true
            initialBorderColor = cellView.layer.borderColor
            initialBorderWidth = cellView.layer.borderWidth
        }

        
        cellView.layer.borderWidth = 3.5
        cellView.layer.borderColor = UIColor(red: 175/255, green: 1.0, blue: 175/255, alpha: 1.0).CGColor
        
        cellLabel.textColor = UIColor(red: 175/255, green: 1.0, blue: 175/255, alpha: 1.0)
    }
    
    func didDeselect(){
        
        initialValuesSet = false
        
        cellView.layer.borderWidth = initialBorderWidth!
        cellView.layer.borderColor = initialBorderColor
        
        cellLabel.textColor = UIColor(CGColor: initialBorderColor!)
    }
}
