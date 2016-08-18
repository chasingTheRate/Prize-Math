//
//  OceanView.swift
//  Prize Math
//
//  Created by Mark Eaton on 4/13/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class OceanView: UIView {


    private var startPath: CGPath!
    private var endPath: CGPath!
    
    private var bottomCornerRight: CGPoint!
    private var bottomCornerLeft: CGPoint!
    private var pathLayer: CAShapeLayer!
    
    var waveFillColor: CGColor = UIColor.blueColor().CGColor
    var waveStrokeColor: CGColor = UIColor.whiteColor().CGColor
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.clearColor()
        
        var path = UIBezierPath()
        
        let startPoint = CGPoint(x: -10.0, y: self.bounds.height * (1/4))
        let endPoint = CGPoint(x: self.bounds.width + 10.0, y: self.bounds.height * (1/3))
        var cp1 = CGPoint(x: self.bounds.width * (1/4), y: 20.0)
        var cp2 = CGPoint(x: self.bounds.width * (3/4), y: -40.0)
        let bottomCornerRight = CGPoint(x: self.bounds.width + 10.0, y: self.bounds.height)
        let bottomCornerLeft = CGPoint(x: -10.0, y: self.bounds.height)
        
        path.moveToPoint(startPoint)
        path.addCurveToPoint(endPoint, controlPoint1: cp1, controlPoint2: cp2)
        path.addLineToPoint(bottomCornerRight)
        path.addLineToPoint(bottomCornerLeft)
        path.addLineToPoint(startPoint)
        path.closePath()

        startPath = path.CGPath
        
        path = UIBezierPath()
        
        cp1 = CGPoint(x: self.bounds.width * (1/4), y: -40.0)
        cp2 = CGPoint(x: self.bounds.width * (3/4), y: 20.0)
        
        path.moveToPoint(startPoint)
        path.addCurveToPoint(endPoint, controlPoint1: cp1, controlPoint2: cp2)
        path.addLineToPoint(bottomCornerRight)
        path.addLineToPoint(bottomCornerLeft)
        path.addLineToPoint(startPoint)
        path.closePath()

        endPath = path.CGPath
        pathLayer = CAShapeLayer()
        pathLayer.path = self.startPath
        pathLayer.lineWidth = 3.0
        
        self.layer.addSublayer(pathLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pathLayer.fillColor = waveFillColor
        pathLayer.strokeColor = waveStrokeColor
        
    }

    func animate(){
        
        let duration = 2.0
        
        let anim = CABasicAnimation(keyPath: "path")
        anim.toValue = endPath
        anim.fromValue = startPath
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.duration = duration
        anim.fillMode = kCAFillModeBoth
        anim.repeatCount = 1
        anim.autoreverses = true
        
        pathLayer.addAnimation(anim, forKey: "nada")
        
    }

}
