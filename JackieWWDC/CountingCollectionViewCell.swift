//
//  CountingCollectionViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 4/4/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class CountingCollectionViewCell: TypeCollectionViewCell {
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    
    override func startAnimation() {
        
        let time: NSTimeInterval = 2.5
        
        if !isAnimating{
//            isAnimating = true
//            timer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
//            timer.fire()
            animate()
        }
    }
    
    override func endAnimation() {
        
        self.cellView.layer.removeAllAnimations()
        
        isAnimating = false
        timer.invalidate()
        labelOne.layer.removeAllAnimations()
        labelTwo.layer.removeAllAnimations()
        labelThree.layer.removeAllAnimations()
    }
    
    override func animate(){

        let duration: NSTimeInterval = 0.5
        let maxTransform: CGFloat = 1.6
        let minTransform: CGFloat = 0.625
    
        UIView.animateWithDuration(duration, delay: 0.0, options: [.CurveEaseIn, .TransitionCrossDissolve], animations: {
            self.labelOne.transform = CGAffineTransformScale(self.labelOne.transform, maxTransform, maxTransform)
            }, completion: {finished in
                UIView.animateWithDuration(duration + 0.20, animations: {
                    self.labelOne.transform = CGAffineTransformScale(self.labelOne.transform, minTransform, minTransform)
                    }, completion: nil)})

        UIView.animateWithDuration(duration, delay: duration, options: .CurveEaseIn, animations: {
                self.labelTwo.transform = CGAffineTransformScale(self.labelTwo.transform, maxTransform, maxTransform)
            }, completion: {finished in
                UIView.animateWithDuration(duration, animations: {self.labelTwo.transform = CGAffineTransformScale(self.labelTwo.transform, minTransform, minTransform)
                    }, completion: nil)})
        
        UIView.animateWithDuration(duration, delay: 2.0 * duration, options: .CurveEaseIn, animations: {
            self.labelThree.transform = CGAffineTransformScale(self.labelThree.transform, maxTransform, maxTransform)
            }, completion: {finished in
                UIView.animateWithDuration(duration, animations: {self.labelThree.transform = CGAffineTransformScale(self.labelThree.transform, minTransform, minTransform)
                    self.labelThree.textColor = UIColor.whiteColor()
                    }, completion: nil)})
    }

}
