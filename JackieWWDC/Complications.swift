//
//  Complications.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/10/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

protocol ComplicationsDelegate{
    func changeAnswer(sender: String)
}

class Complications: NSObject {
    
    
    //MARK: Variables
    
    private let manager = CMMotionManager()
    private var animator: UIDynamicAnimator?
    private var gravity: UIGravityBehavior?
    private var collision: UICollisionBehavior?
    
    var delegate: ComplicationsDelegate?

    var items: [Complication] = [Complication(title: "NONE", action: nil, imagePath: "imagePath"), Complication(title: "GRAVITY", action: "action", imagePath: "imagePath"),
        Complication(title: "DECOY", action: "action", imagePath: "imagePath"),
        Complication(title: "ORBIT", action: "action", imagePath: "imagePath"),
        Complication(title: "GHOST", action: "action", imagePath: "imagePath")]
    
    var active: Bool = false
    var decoySet = false
    
    //MARK: Gravity
    
    func gravity(sender: InputView){
        
        animator = UIDynamicAnimator(referenceView: sender)
    
        let itemBehavior = UIDynamicItemBehavior(items: sender.viewCollection)
        itemBehavior.elasticity = 0.9
        
        gravity = UIGravityBehavior(items: sender.viewCollection)
        collision = UICollisionBehavior(items: sender.viewCollection)
        collision!.translatesReferenceBoundsIntoBoundary = true
        
        if manager.deviceMotionAvailable{
            manager.deviceMotionUpdateInterval = 0.1
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: updateGravityDirection)
        }
        
        animator!.addBehavior(gravity!)
        animator!.addBehavior(collision!)
        animator!.addBehavior(itemBehavior)
        
      
    }
    
    private func updateGravityDirection(motion: CMDeviceMotion?, error: NSError?){
        
        let gravity = motion!.gravity
        
        let gravity_x = CGFloat(gravity.x)
        let gravity_y = -CGFloat(gravity.y)
        
        
        dispatch_async(dispatch_get_main_queue(), {
            self.gravity!.gravityDirection = CGVectorMake(gravity_x, gravity_y)
        })
        
    }
    
    //MARK: Orbit
    
    func orbit(sender: UIView){
        
        let duration: NSTimeInterval = 1.0
        let innerRadius: CGFloat = 0.45 * sender.bounds.height/2
        let outerRadius: CGFloat = 0.85 * sender.bounds.height/2
        
        let innerRadiusScale: CGFloat = 0.75
        let outerRadiusScale: CGFloat = 0.85
        
        for view in sender.subviews as [UIView]{
            
                switch view.tag{
                    
                case 0:
                    
                    UIView.animateWithDuration(duration, animations: {
                        
                        view.transform = CGAffineTransformMakeScale(innerRadiusScale, innerRadiusScale)
                        view.center = CGPoint(x: sender.center.x, y: sender.center.y + outerRadius)
                        
                        }, completion: {finished in self.orbitAnimation(view, origin: sender.center, radius: outerRadius, angle: 90)})
                    
                case 1:
                    
                    UIView.animateWithDuration(duration, animations: {
                        
                        view.transform = CGAffineTransformMakeScale(innerRadiusScale, innerRadiusScale)
                        view.center = CGPoint(x: sender.center.x - cos(self.convertDegToRadians(45)) * outerRadius, y: (sender.center.y + sin(self.convertDegToRadians(45)) * outerRadius))
        
                        }, completion: {finished in self.orbitAnimation(view, origin: sender.center, radius: outerRadius, angle: 135)})
                
                case 2:
        
                    UIView.animateWithDuration(duration, animations: {
                        
                        view.transform = CGAffineTransformMakeScale(outerRadiusScale, outerRadiusScale)
                        view.center = CGPoint(x: sender.center.x, y: sender.center.y + innerRadius)
                        
                        }, completion: {finished in self.orbitAnimation(view, origin: sender.center, radius: innerRadius, angle: 90)})
                    
                case 3:
                    
                    UIView.animateWithDuration(duration, animations: {
                        
                        view.transform = CGAffineTransformMakeScale(innerRadiusScale, innerRadiusScale)
                        view.center = CGPoint(x: sender.center.x + cos(self.convertDegToRadians(45)) * outerRadius, y: (sender.center.y + sin(self.convertDegToRadians(45)) * outerRadius))
                        
                        }, completion: {finished in self.orbitAnimation(view, origin: sender.center, radius: outerRadius, angle: 45)})
                
                case 4:
                    
                    
                    UIView.animateWithDuration(duration, animations: {
                        
                        
                        view.transform = CGAffineTransformMakeScale(outerRadiusScale, outerRadiusScale)
                        view.center = CGPoint(x: sender.center.x - innerRadius, y: sender.center.y)
                       
                        }, completion: {finished in self.orbitAnimation(view, origin: sender.center, radius: innerRadius, angle: 180)})
                case 5:
                
                    UIView.animateWithDuration(duration, animations: {
                        
                        view.center = sender.center
                        
                      }, completion: nil)
                    
                case 6:
                    
                    UIView.animateWithDuration(duration, animations: {
                
                        view.transform = CGAffineTransformMakeScale(outerRadiusScale, outerRadiusScale)
                        view.center = CGPoint(x: sender.center.x + innerRadius, y: sender.center.y)
                        
                        }, completion: {finished in self.orbitAnimation(view, origin: sender.center, radius: innerRadius, angle: 0)})
                case 7:
                    
                    UIView.animateWithDuration(duration, animations: {
                        
                        view.transform = CGAffineTransformMakeScale(innerRadiusScale, innerRadiusScale)
                        view.center = CGPoint(x: sender.center.x - cos(self.convertDegToRadians(45)) * outerRadius, y: (sender.center.y - sin(self.convertDegToRadians(45)) * outerRadius))
                        
                        }, completion: {finished in self.orbitAnimation(view, origin: sender.center, radius: outerRadius, angle: 225)})
                            
                        
                case 8:
                    
                    UIView.animateWithDuration(duration, animations: {
                        
                        view.transform = CGAffineTransformMakeScale(outerRadiusScale, outerRadiusScale)
                        view.center = CGPoint(x: sender.center.x, y: sender.center.y - innerRadius)
                        
                        }, completion: {finished in self.orbitAnimation(view, origin: sender.center, radius: innerRadius, angle: 270)})
                    
                case 9:
   
                    UIView.animateWithDuration(duration, animations: {
                        
                        view.transform = CGAffineTransformMakeScale(innerRadiusScale, innerRadiusScale)
                        view.center = CGPoint(x: sender.center.x + cos(self.convertDegToRadians(45)) * outerRadius, y: (sender.center.y - sin(self.convertDegToRadians(45)) * outerRadius))
                        
                        }, completion: {finished in self.orbitAnimation(view, origin: sender.center, radius: outerRadius, angle: 315)})
                    
                default:
                    view.hidden = true
                }
        }
        
    }
    
    private func orbitAnimation(button: UIView, origin: CGPoint, radius: CGFloat, angle: Double){
        
        let path = UIBezierPath()
        
        // create a new CAKeyframeAnimation that animates the objects position
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        if radius < 150{
            anim.duration = 3.0
        }else{
            anim.duration = 5.0
        }
        
        path.addArcWithCenter(origin, radius: radius, startAngle: self.convertDegToRadians(angle + 0.001), endAngle: self.convertDegToRadians(angle), clockwise: true)

        // set the animations path to our bezier curve
        anim.path = path.CGPath
        
        // set some more parameters for the animation
        // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
        anim.rotationMode = kCAAnimationRotateAuto
        anim.repeatCount = Float.infinity
        
        // we add the animation to the squares 'layer' property
        button.layer.addAnimation(anim, forKey: "animate position along path")
        
        //Move Button out of view so as not to interfere with it's animating layer
        button.center = CGPoint(x: -10, y: -10)
    }
    
    //MARK: Decoy

    func decoy(sender: InputView){
        
//        if decoySet == false{
//            
//            for button in sender.viewCollection{
//                let containerView = UIView()
//                containerView.frame = button.frame
//                containerView.center = button.center
//                containerView.tag = button.tag
//                sender.insertSubview(containerView, atIndex: 9 - button.tag)
//                containerView.addSubview(button)
//            }
//        }
        
        //decoySet = true
        
        var randomView = UIView()
        let randomViewIndex = Int(arc4random_uniform(10))
        let randomTitle = Int(arc4random_uniform(10))
        let randomTransition = Int(arc4random_uniform(3))
        
        randomView = sender.subviews[randomViewIndex]
        //let button = randomView.subviews.first as! UIButton
    
//        if randomView.subviews.count == 1 {
//            
//            //Add Decoy Button
//            let decoyButton = UIButton()
//            decoyButton.frame = CGRect(x: 0, y: 0, width: randomView.frame.width, height: randomView.frame.height)
//            decoyButton.backgroundColor = button.backgroundColor
//            decoyButton.layer.borderColor = button.layer.borderColor
//            decoyButton.layer.borderWidth = button.layer.borderWidth
//            decoyButton.layer.cornerRadius = button.layer.cornerRadius
//            decoyButton.titleLabel!.font = button.titleLabel?.font
//            decoyButton.setTitleColor(button.titleColorForState(.Normal), forState: .Normal)
//            decoyButton.alpha = button.alpha
//            decoyButton.tag = button.tag
//            decoyButton.setTitle(randomTitle.description, forState: .Normal)
//            decoyButton.addTarget(self,action: #selector(changeAnswer), forControlEvents: .TouchUpInside)
//            decoyButton.hidden = true
//            
//            randomView.addSubview(decoyButton)
//
//
//        }else{
//            
//            //Add Decoy Button
//            let decoyButton = UIButton()
//            decoyButton.frame = CGRect(x: 0, y: 0, width: randomView.frame.width, height: randomView.frame.height)
//            decoyButton.backgroundColor = button.backgroundColor
//            decoyButton.layer.borderColor = button.layer.borderColor
//            decoyButton.layer.borderWidth = button.layer.borderWidth
//            decoyButton.layer.cornerRadius = button.layer.cornerRadius
//            decoyButton.titleLabel!.font = button.titleLabel?.font
//            decoyButton.setTitleColor(button.titleColorForState(.Normal), forState: .Normal)
//            decoyButton.alpha = button.alpha
//            decoyButton.tag = button.tag
//            decoyButton.setTitle(randomTitle.description, forState: .Normal)
//            decoyButton.addTarget(self,action: #selector(changeAnswer), forControlEvents: .TouchUpInside)
//            decoyButton.hidden = true
//            
//            //Move 1st Decoy to 1st Position
//            randomView.insertSubview(randomView.subviews.last!, atIndex: 0)
//            
//            //Add New Decoy Button
//            randomView.addSubview(decoyButton)
//            
//        }
    
        var transitionOptions: UIViewAnimationOptions = .ShowHideTransitionViews
        
        switch randomTransition{
        case 0:
            transitionOptions.insert(.TransitionFlipFromBottom)
        case 1:
            transitionOptions.insert(.TransitionFlipFromLeft)
        case 2:
            transitionOptions.insert(.TransitionFlipFromRight)
        case 3:
            transitionOptions.insert(.TransitionFlipFromTop)
        default:
            break
        }
        
    
        UIView.transitionWithView(randomView, duration: 0.5, options: transitionOptions, animations: {

            let label = randomView.subviews.last! as! UILabel
            label.text = randomTitle.description

                }, completion: nil)
        //})
    }
    
    //MARK: Ghost
    
    func ghost(sender: UIView){
        
        UIView.animateWithDuration(1.0, animations: {
            
            for view in sender.subviews{
                view.alpha = 0.0
            }
            
            }, completion: {finished in
                
                for view in sender.subviews{
                    let visualView = view as! UIVisualEffectView
                    let button = visualView.contentView.subviews.first as! UIButton
                    let label = visualView.subviews.last as! UILabel
                    
                    button.backgroundColor = UIColor.clearColor()
                    button.setTitleColor(UIColor.clearColor(), forState: .Normal)
                    button.layer.borderColor = UIColor.clearColor().CGColor
                    
                    label.textColor = UIColor.clearColor()
                    
                    view.alpha = 1.0
                }
        })
        
        //***Add Ghost Image Animimation***
    }
    
    //MARK: Conversions
    
    private func convertDegToRadians(degrees: Double) -> CGFloat{
        
        return CGFloat(degrees * M_PI/180)
    }
    
    //MARK: Protocol Function(s)
    
    func changeAnswer(sender: UIButton){
        delegate!.changeAnswer(sender.tag.description)
    }
    
    //MARK: Clean Up
    
    func cleanUp(sender: InputView){
        
        animator?.removeAllBehaviors()
        
        if decoySet{
            
            for view in sender.subviews{
                
                view.subviews.first!.hidden = false
                sender.addSubview(view.subviews.first!)
                view.removeFromSuperview()
            }
            
            //Reset Decoy variable
            decoySet = false
        }
    }
}