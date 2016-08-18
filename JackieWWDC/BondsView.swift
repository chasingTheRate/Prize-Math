//
//  BondsView.swift
//  Prize Math
//
//  Created by Mark Eaton on 3/8/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class BondsView: UIView {

    let colors = Colors()
    
    var wholeBubble: UILabel!
    var firstPartBubble: UILabel!
    var secondPartBubble: UILabel!
    
    var wholeValue = ""
    var firstValue = ""
    var secondValue = ""
    
    var labelTextColor = UIColor.whiteColor()
    
    
    override func layoutSubviews() {
        
        //print("layout subviews")
        
        let totalBubbleDia = self.bounds.height * 0.55
        let partBubbleDia = self.bounds.height * 0.40
        
        wholeBubble.frame = CGRect(x: self.bounds.width/2 - totalBubbleDia/2, y: 15.0, width: totalBubbleDia, height: totalBubbleDia)
        
        wholeBubble.layer.cornerRadius = totalBubbleDia/2
        wholeBubble.layer.masksToBounds = true
        wholeBubble.textAlignment = .Center
        wholeBubble.textColor = colors.secondaryColor[0]
        wholeBubble.font = UIFont(name: wholeBubble.font.fontName, size: 30)
        wholeBubble.backgroundColor = UIColor.whiteColor()
        wholeBubble.layer.borderColor = colors.secondaryColor[0]!.CGColor
        wholeBubble.layer.borderWidth = 1.5
        
        firstPartBubble.frame = CGRect(x: self.bounds.width * 0.25 - partBubbleDia/2, y: self.bounds.height - (partBubbleDia + 15.0), width: partBubbleDia, height: partBubbleDia)
        firstPartBubble.layer.cornerRadius = partBubbleDia/2
        firstPartBubble.layer.masksToBounds = true
        firstPartBubble.textAlignment = .Center
        firstPartBubble.textColor = colors.secondaryColor[0]
        firstPartBubble.font = UIFont(name: firstPartBubble.font.fontName, size: 25)
        firstPartBubble.backgroundColor = UIColor.whiteColor()
        firstPartBubble.layer.borderColor = colors.secondaryColor[0]!.CGColor
        firstPartBubble.layer.borderWidth = 1.0
        
        secondPartBubble.frame = CGRect(x: self.bounds.width * 0.75 - partBubbleDia/2, y: self.bounds.height - (partBubbleDia + 15.0), width: partBubbleDia, height: partBubbleDia)
        secondPartBubble.layer.cornerRadius = partBubbleDia/2
        secondPartBubble.layer.masksToBounds = true
        secondPartBubble.textAlignment = .Center
        secondPartBubble.textColor = colors.secondaryColor[0]
        secondPartBubble.font = UIFont(name: secondPartBubble.font.fontName, size: 25)
        secondPartBubble.backgroundColor = UIColor.whiteColor()
        secondPartBubble.layer.borderColor = colors.secondaryColor[0]!.CGColor
        secondPartBubble.layer.borderWidth = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        wholeBubble = UILabel(frame: CGRect.zero)
        firstPartBubble = UILabel(frame: CGRect.zero)
        secondPartBubble = UILabel(frame: CGRect.zero)
        
        wholeBubble.adjustsFontSizeToFitWidth = true
        wholeBubble.numberOfLines = 0
        
        firstPartBubble.adjustsFontSizeToFitWidth = true
        firstPartBubble.numberOfLines = 0
        
        secondPartBubble.adjustsFontSizeToFitWidth = true
        secondPartBubble.numberOfLines = 0
        
        self.addSubview(wholeBubble)
        self.addSubview(firstPartBubble)
        self.addSubview(secondPartBubble)
    }
    
    override func drawRect(rect: CGRect) {
        
        //Draw Lines
        
        let path = UIBezierPath()
        
        path.moveToPoint(CGPoint(x: wholeBubble!.center.x, y: wholeBubble!.center.y))
        path.addLineToPoint(CGPoint(x: firstPartBubble!.center.x, y: firstPartBubble!.center.y))
        
        path.moveToPoint(CGPoint(x: wholeBubble!.center.x, y: wholeBubble!.center.y))
        path.addLineToPoint(CGPoint(x: secondPartBubble!.center.x, y: secondPartBubble!.center.y))
        
        path.lineWidth = 5.0
        colors.secondaryColor[0]!.setStroke()
        path.stroke()
    }
    
    func updateLabels(){
        wholeBubble.text = wholeValue
        firstPartBubble.text = firstValue
        secondPartBubble.text = secondValue
    }

}
