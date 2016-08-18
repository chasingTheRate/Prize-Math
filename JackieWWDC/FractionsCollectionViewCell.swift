//
//  FractionsCollectionViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 4/11/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class FractionsCollectionViewCell: TypeCollectionViewCell {
    
    @IBOutlet weak var labelNumerator: UILabel!
    @IBOutlet weak var labelDenominator: UILabel!
    @IBOutlet weak var viewVinculum: UIView!

    
    override func animate(){

        let duration = 0.75
        
        UIView.animateWithDuration(duration, animations: {
            self.labelNumerator.alpha = 0.0
            self.labelDenominator.alpha = 0.0
            self.viewVinculum.alpha = 0.0
            }, completion: { finished in
                self.labelNumerator.center.y = -33
                self.labelNumerator.alpha = 1.0
                self.labelNumerator.text = "2"
                self.labelDenominator.center.y = 100
                self.labelDenominator.alpha = 1.0
                self.labelDenominator.text = "4"
                self.animateVinculum()
        })
    }

    override func startAnimation() {
        
        let time: NSTimeInterval = 3.0
        
        if !isAnimating{
//            isAnimating = true
//            timer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
//            self.timer.fire()
            animate()
        }
    }
    
    override func endAnimation() {
        
        let duration = 0.5
        isAnimating = false
        timer.invalidate()
        
        UIView.animateWithDuration(duration, animations: {
            self.labelNumerator.alpha = 0
            self.labelDenominator.alpha = 0
            self.viewVinculum.alpha = 0
          
            }, completion: {finished in
                self.labelNumerator.text = "1"
                self.labelDenominator.text = "2"
                
                UIView.animateWithDuration(duration, animations: {
                    self.labelNumerator.alpha = 1.0
                    self.labelDenominator.alpha = 1.0
                    self.viewVinculum.alpha = 1.0
                    }, completion: nil)
        })
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.viewVinculum.alpha = 1.0
        self.cellView.layer.sublayers?.removeLast()
        
        UIView.transitionWithView(labelNumerator, duration: 0.75, options: .TransitionFlipFromRight, animations: {
            self.labelNumerator.text = "1"
            }, completion: nil)
        
        UIView.transitionWithView(labelDenominator, duration: 0.75, options: .TransitionFlipFromRight, animations: {
            self.labelDenominator.text = "2"
            }, completion: nil)
        
    }
    
    private func animateVinculum(){
        
        let pathWidth: CGFloat = 3.0
        let yLoc = self.cellView.bounds.height/2.0
        let xStart: CGFloat = 27.5
        let xEnd: CGFloat = 52.5
        let duration = 1.0
       
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: xStart, y: yLoc))
        path.addLineToPoint(CGPoint(x: xEnd, y: yLoc))
        
        //Create a CAShape Layer
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.frame = self.cellView.bounds
        pathLayer.path = path.CGPath
        pathLayer.strokeColor = UIColor.whiteColor().CGColor
        pathLayer.lineWidth = pathWidth
    
        self.cellView.layer.addSublayer(pathLayer)
        
        let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.delegate = self
        pathAnimation.duration = duration
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.removedOnCompletion = false
        //Animation will happen right away
        pathLayer.addAnimation(pathAnimation, forKey: "strokeEnd")
        
        
        UIView.animateWithDuration(duration, animations: {
            self.labelNumerator.center.y = 21.5
            self.labelDenominator.center.y = 58.5
        }, completion: nil)
        
    }
}
