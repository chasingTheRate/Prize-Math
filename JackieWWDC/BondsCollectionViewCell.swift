//
//  BondsCollectionViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 4/5/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class BondsCollectionViewCell: TypeCollectionViewCell {
    
    @IBOutlet weak var viewLargeBubble: UIView!
    @IBOutlet weak var viewSmallBubbleOne: UIView!
    @IBOutlet weak var viewSmallBubbleTwo: UIView!
    
    @IBOutlet weak var labelLargeBubble: UILabel!
    @IBOutlet weak var labelSmallBubbleOne: UILabel!
    @IBOutlet weak var labelSmallBubbleTwo: UILabel!
    
    var randomBubble: UILabel?
    var randomView: UIView?
    var animationCount = 0
    
    override func startAnimation() {
        
        let time: NSTimeInterval = 1.0
        
        if !isAnimating{
//            isAnimating = true
//            timer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
//            timer.fire()
            animate()
        }
    }
    
    override func endAnimation() {
        
        let duration: NSTimeInterval = 0.25
        
        isAnimating = false
        timer.invalidate()
        
        UIView.animateWithDuration(duration, delay: 0.0, options: [.CurveEaseIn], animations: {
            self.labelLargeBubble.alpha = 1.0
            self.labelSmallBubbleOne.alpha = 1.0
            self.labelSmallBubbleTwo.alpha = 1.0
            }, completion: nil)
    }
    
    override func animate() {
        
        let duration: NSTimeInterval = 0.25
    
        //Reset random bubble if it exists
        if let bubble = randomBubble{
            UIView.animateWithDuration(duration, delay: 0.0, options: [.CurveEaseIn], animations: {
                bubble.alpha = 1.0
                }, completion: nil)
        }
        
        //Set Random Bubble based on Count value
        switch animationCount{
        case 0:
            randomBubble = labelLargeBubble
        case 1:
            randomBubble = labelSmallBubbleOne
        default:
            randomBubble = labelSmallBubbleTwo
        }
        
        //Increment Count
        if animationCount == 2{
            animationCount = 0
        }else{
            animationCount += 1
        }
        
        //Animate Bubble Label Alpha
        UIView.animateWithDuration(duration, delay: 0.0, options: [.CurveEaseIn], animations: {
            self.randomBubble!.alpha = 0.0
            }, completion: nil)
    }
}
