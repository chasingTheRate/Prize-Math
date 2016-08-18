//
//  SpaceView.swift
//  Prize Math
//
//  Created by Mark Eaton on 4/14/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class SpaceView: UIView {
    
    var starGradientColor = UIColor.blackColor().CGColor{
        didSet{
            setNeedsDisplay()
        }
    }
    
    var starView: StarView!
    var atmosphereView: UIView!
    var backgroundStars: UIView!
    var moonView: UIView!
    
    var moonColor = UIColor.redColor()
    var moonLayer = CAShapeLayer()
    var moonOrbit: CGPath!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let moonDia: CGFloat = 26.0
        
        starView = StarView(frame: self.bounds)
        starView.backgroundColor = UIColor.clearColor()
        
        atmosphereView = UIView(frame: self.bounds)
        atmosphereView.backgroundColor = UIColor.blackColor()
        atmosphereView.layer.opacity = 0.0
        
        backgroundStars = UIView(frame: self.bounds)
        backgroundStars.backgroundColor = UIColor.clearColor()
        
        let moonRect = CGRect(x: -moonDia, y: 40, width: moonDia, height: moonDia)
        moonView = UIView(frame: moonRect)
        moonView.layer.cornerRadius = moonView.bounds.width/2.0
        moonView.layer.masksToBounds = false
        
        self.addSubview(atmosphereView)
        self.addSubview(backgroundStars)
        self.addSubview(starView)
        self.addSubview(moonView)
    }


    override func drawRect(rect: CGRect) {
        
        moonView.backgroundColor = moonColor
        
        //Draw Moon Arc
        
        let arcCenter = CGPoint(x: 40.0, y: 100.0)
        let arcRadius = CGFloat(70)
        let startAngle = Functions.convertDegToRadians(225)
        let endAngle = Functions.convertDegToRadians(315)

        let moonArc = UIBezierPath(arcCenter: arcCenter, radius: arcRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        //UIColor.yellowColor().setStroke()
        //moonArc.stroke()
        
        moonOrbit = moonArc.CGPath
        
        //Add background star
        
        for _ in 0...30{
            
            let x = CGFloat(arc4random_uniform(80))
            let y = CGFloat(arc4random_uniform(80))
            let starSize = CGFloat(arc4random_uniform(15))/10.0
        
            let star = UIView(frame: CGRect(x: x, y: y, width: starSize, height: starSize))
            star.backgroundColor = UIColor.whiteColor()
            backgroundStars.addSubview(star)
        }
    }
    
    func animate(){
    
        let duration = 5.0
        
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = moonOrbit
        anim.duration = duration
        anim.delegate = self
    
        moonView.layer.addAnimation(anim, forKey: "nada")
        
        let delay = 1.50
        
        let _ = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(animateMoonLayerOpacity), userInfo: nil, repeats: false)
    
        //Animate background stars alpha
        
        for view in backgroundStars.subviews{
            
            let time = Double((arc4random_uniform(10-5) + 5))/10.0
            let delay = Double(arc4random_uniform(10))/10.0
            
            UIView.animateKeyframesWithDuration(time, delay: delay, options: [.Repeat, .Autoreverse], animations: {
                view.alpha = 0.0
                }, completion: nil)
        }
    }
    
    func animateMoonLayerOpacity(){
        
        let duration2 = 1.25
        
        let anim2 = CABasicAnimation(keyPath: "opacity")
        
        anim2.fromValue = 0.0
        anim2.toValue = 0.8
        anim2.duration = duration2
        anim2.autoreverses = true
        
        atmosphereView.layer.addAnimation(anim2, forKey: "moon")
        
        UIView.animateWithDuration(1.25, delay: 0.25, options: [], animations: {
            self.moonView.backgroundColor = UIColor.blackColor()
            }, completion: {finished in
                UIView.animateWithDuration(1.25, delay: 0.0, options: [], animations: {
                    self.moonView.backgroundColor = self.moonColor
                }, completion: nil)
        })
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        for view in backgroundStars.subviews{
            view.alpha = 1.0
            view.layer.removeAllAnimations()
        }
    }
}

class StarView: UIView{
    
    let starDia: CGFloat = 25.0
    
    override func drawRect(rect: CGRect) {
        
        //Define Gradient
        
        let context = UIGraphicsGetCurrentContext()
        let locations: [CGFloat] = [0.0, 0.25, 0.50, 0.75, 1.0]
        
        let colors = [UIColor.whiteColor().colorWithAlphaComponent(1.0).CGColor,
                      UIColor.whiteColor().colorWithAlphaComponent(0.6).CGColor,
                      UIColor.whiteColor().colorWithAlphaComponent(0.4).CGColor,
                      UIColor.whiteColor().colorWithAlphaComponent(0.2).CGColor,
                      UIColor.clearColor().CGColor]
        
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradientCreateWithColors(colorspace,
                                                  colors, locations)
        
        var startPoint = CGPoint()
        var endPoint = CGPoint()
        startPoint.x = 40
        startPoint.y = 30
        endPoint.x = 40
        endPoint.y = 30
        let startRadius: CGFloat = 0
        let endRadius: CGFloat = 25
        
        CGContextDrawRadialGradient (context, gradient, startPoint,
                                     startRadius, endPoint, endRadius,
                                     .DrawsAfterEndLocation)
        
        //Draw Star Center
        let starRect = CGRect(x: 40 - starDia/2, y: 30 - starDia/2, width: starDia, height: starDia)
        let starPath = UIBezierPath(ovalInRect: starRect)
        UIColor.whiteColor().setFill()
        starPath.fill()
    }
    
}
