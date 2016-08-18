//
//  BasicCollectionViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 4/4/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class BasicCollectionViewCell: TypeCollectionViewCell {
    
    @IBOutlet weak var labelAdd: UILabel!
    @IBOutlet weak var animateLabelAdd: UILabel!
    @IBOutlet weak var labelMultiply: UILabel!
    @IBOutlet weak var animateLabelMultiply: UILabel!
    @IBOutlet weak var labelSubtract: UILabel!
    @IBOutlet weak var animateLabelSubtract: UILabel!
    @IBOutlet weak var labelDivide: UILabel!
    @IBOutlet weak var animateLabelDivide: UILabel!
    
    override func startAnimation() {
        
        animateLabelAdd.hidden = false
        animateLabelSubtract.hidden = false
        animateLabelMultiply.hidden = false
        animateLabelDivide.hidden = false
        
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
        animateLabelAdd.layer.removeAllAnimations()
        animateLabelSubtract.layer.removeAllAnimations()
        animateLabelMultiply.layer.removeAllAnimations()
        animateLabelDivide.layer.removeAllAnimations()
        
        animateLabelAdd.hidden = true
        animateLabelSubtract.hidden = true
        animateLabelMultiply.hidden = true
        animateLabelDivide.hidden = true
    }
    
    override func animate() {
        
        let duration: NSTimeInterval = 0.50
        
        UIView.animateWithDuration(duration, delay: 0.0, options: [.CurveEaseIn], animations: {
            self.animateLabelAdd.alpha = 1.0
            }, completion: {finished in
                UIView.animateWithDuration(duration + 0.20, animations: {
                    self.animateLabelAdd.alpha = 0.0
                    }, completion: nil)})
        
        UIView.animateWithDuration(duration, delay: duration, options: [.CurveEaseIn], animations: {
            self.animateLabelSubtract.alpha = 1.0
            self.animateLabelDivide.alpha = 1.0
            }, completion: {finished in
                UIView.animateWithDuration(duration + 0.20, animations: {
                    self.animateLabelSubtract.alpha = 0.0
                    self.animateLabelDivide.alpha = 0.0
                    }, completion: nil)})
        
        UIView.animateWithDuration(duration, delay: 2.0 * duration, options: [.CurveEaseIn], animations: {
            self.animateLabelMultiply.alpha = 1.0
            }, completion: {finished in
                UIView.animateWithDuration(duration + 0.20, animations: {
                    self.animateLabelMultiply.alpha = 0.0
                    }, completion: nil)})
    }
}
