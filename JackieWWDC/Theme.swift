//
//  Theme.swift
//  Prize Math
//
//  Created by Mark Eaton on 3/29/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import Foundation
import UIKit

class Theme: NSObject{
    
    var superview: UIView?
    var backgroundViewTag = 100
    var id: String?
    var backgroundImageName: String?
    var backgroundImageBlurEffect: UIBlurEffectStyle = .Light
    
    var inputBlurEffectStyle: UIBlurEffectStyle = .Light
    var inputBorderColor = UIColor.whiteColor()
    var inputBackgroundColor = UIColor.whiteColor()
    
    var navBarStyle: UIBarStyle = .Default
    var navBarTintColor = UIColor.blackColor()

    var collectionViewCellImage: UIImage?
    var collectionViewCellTitle: String?
    var collectionViewCellBackgroundColor = UIColor.whiteColor()
    var collectionViewCellTextColor = UIColor.whiteColor()
    var collectionViewCellSelectableTextColor = UIColor.whiteColor()
    var collectionViewCellBorderColor = UIColor.whiteColor()
    var collectionViewCellBorderWidth: CGFloat = 1.0
    
    var tableViewCellTextColor = UIColor.whiteColor()
    var tableViewCellSelectableTextColor = UIColor.whiteColor()
    var tableViewCellBackgroundColor = UIColor.whiteColor()
    var tableViewHeaderViewBackgroundColor = UIColor.whiteColor()
    var tableViewHeaderViewTextColor = UIColor.whiteColor()
    var tableViewFooterViewBackgroundColor = UIColor.whiteColor()
    var tableViewFooterViewTextColor = UIColor.whiteColor()
    var tableViewSwitchOnTintColor = UIColor.whiteColor()
    var tableViewSwitchTintColor = UIColor.whiteColor()
    var tableViewIconColor = UIColor.whiteColor()
    
    func animateBackgroundView(){
        //Overriden in subclasses
    }
    
    //Remove background views after animation completes
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        let tag = anim.valueForKey("position") as! Int
    
        if let sv = superview{
            for view in (sv.subviews){
                if view.tag == tag{
                    view.removeFromSuperview()
                    break
                }
            }
        }
    }
    
    override init(){
        
    }
    
}

class Ocean: Theme{
    
    
    override init(){
        super.init()
        
        id = "ocean"
        backgroundImageName = "oceanBackground"
        collectionViewCellTitle = "OCEAN"
        
        inputBlurEffectStyle = .Light
        inputBorderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        navBarTintColor = UIColor(red: 0.0, green: 64/255, blue: 128/255, alpha: 1.0)
        
        tableViewCellTextColor = UIColor.whiteColor()
        tableViewCellSelectableTextColor = UIColor(red: 1.0, green: 150/255, blue: 150/255, alpha: 1.0)
        tableViewCellBackgroundColor = UIColor.clearColor()
        tableViewHeaderViewBackgroundColor = UIColor(red: 0.0, green: 64/255, blue: 128/255, alpha: 1.0)
        tableViewSwitchTintColor = UIColor(red: 175/255, green: 1.0, blue: 1.0, alpha: 1.0)
        tableViewSwitchOnTintColor = UIColor(red: 1.0, green: 150/255, blue: 150/255, alpha: 1.0)
        tableViewIconColor = UIColor(red: 0.0, green: 64/255, blue: 128/255, alpha: 0.5)
        
        collectionViewCellBackgroundColor = UIColor.clearColor()
        collectionViewCellTextColor = UIColor.whiteColor()
        collectionViewCellSelectableTextColor = UIColor(red: 1.0, green: 150/255, blue: 150/255, alpha: 1.0)
        collectionViewCellBorderColor = UIColor(red: 175/255, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionViewCellBorderWidth = 2.0
    }

    override func animateBackgroundView() {
        
        let sv: UIView!
        
        //Exit method if superview is nil
        if superview == nil{
            return
        }else{
           sv = superview!
        }
        
        var beginXPos: CGFloat
        var endXPos: CGFloat
        
        var beginYPos: CGFloat
        var endYPos: CGFloat
        
        var xOffset: CGFloat
        var yOffset: CGFloat
        
        //Start object either L->R, L->R
        
        if arc4random_uniform(2) == 0 {
            beginXPos = CGFloat(-200)
            endXPos = (sv.bounds.width + 200)
            xOffset = CGFloat(arc4random_uniform(UInt32(superview!.bounds.width/3.0)))
        }else{
            beginXPos = (sv.bounds.width + 200)
            endXPos = CGFloat(-200)
            xOffset = -CGFloat(arc4random_uniform(UInt32(sv.bounds.width/3.0)))
        }
        
        //Start object either T->B, B->T
        
        beginYPos = CGFloat(arc4random_uniform(UInt32(sv.bounds.height)))
        endYPos = CGFloat(arc4random_uniform(UInt32(sv.bounds.height)))
        
        yOffset = CGFloat(arc4random_uniform(UInt32(sv.bounds.height/3.0)))
        
        if endYPos < beginYPos{
            yOffset = -yOffset
        }
        
        let color = arc4random_uniform(5)
        let duration = NSTimeInterval(arc4random_uniform(10-3) + 3)
        let objectHeight = CGFloat(arc4random_uniform(100-15) + 15)
        let objectWidthMultiplier = CGFloat(arc4random_uniform(200-100) + 100)
        let objectWidth = objectHeight * objectWidthMultiplier/100.0
        
        let test = UIView(frame: CGRect(x: beginXPos, y: beginYPos, width: objectWidth, height: objectHeight))
        test.tag = backgroundViewTag
        
        //Increment tag id.Reset if > 200
        if backgroundViewTag < 200{
            backgroundViewTag += 1
        }else{
            backgroundViewTag = 100
        }
        
        test.layer.cornerRadius = objectWidth/2
        test.layer.masksToBounds = true
        
        switch color{
        case 0:
            test.backgroundColor = UIColor.yellowColor()
        case 1:
            test.backgroundColor = UIColor.redColor()
        case 2:
            test.backgroundColor = UIColor.orangeColor()
        case 3:
            test.backgroundColor = UIColor.purpleColor()
        case 4:
            test.backgroundColor = UIColor.whiteColor()
        default:
            test.backgroundColor = UIColor.greenColor()
        }
        
        sv.insertSubview(test, atIndex: 0)
        
        let path = UIBezierPath()
        
        let startPoint = CGPoint(x: beginXPos, y: beginYPos)
        let endPoint = CGPoint(x: endXPos, y: endYPos)
        let controlPoint1 = CGPoint(x: beginXPos + xOffset , y: beginYPos + yOffset)
        let controlPoint2 = CGPoint(x: beginXPos + 2.0 * xOffset , y: beginYPos + 2.0 * yOffset)
        
        path.moveToPoint(startPoint)
        path.addCurveToPoint(endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        //Path Animation
        
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.setValue(test.tag, forKey: "position")
        anim.path = path.CGPath
        anim.rotationMode = kCAAnimationRotateAuto
        anim.repeatCount = 0
        anim.duration = duration
        anim.removedOnCompletion = true
        anim.delegate = self
        
        //Add Animation to Layer
        test.layer.addAnimation(anim, forKey: "animate position along path")
    }
    
}

//MARK - Space

class Space: Theme{
    
    override init(){
        super.init()
        
        id = "space"
        backgroundImageName = "spaceBackground"
        collectionViewCellTitle = "SPACE"
        
        backgroundImageBlurEffect = .Dark
        inputBlurEffectStyle = .Dark
        inputBorderColor = UIColor.whiteColor()
        
        navBarStyle = .BlackTranslucent
        navBarTintColor = UIColor.whiteColor()
        
        tableViewCellTextColor = UIColor.whiteColor()
        tableViewCellSelectableTextColor = UIColor.redColor()
        tableViewCellBackgroundColor = UIColor.clearColor()
        tableViewHeaderViewBackgroundColor = UIColor.blackColor()
        tableViewSwitchTintColor = UIColor.whiteColor()
        tableViewSwitchOnTintColor = UIColor.redColor()
        tableViewIconColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        collectionViewCellBackgroundColor = UIColor.clearColor()
        collectionViewCellTextColor = UIColor.whiteColor()
        collectionViewCellSelectableTextColor = UIColor.redColor()
        collectionViewCellBorderColor = UIColor.grayColor()
        collectionViewCellBorderWidth = 2.0
    }
    
    override func animateBackgroundView() {
        
        let sv: UIView!
        
        //Exit method if superview is nil
        if superview == nil{
            return
        }else{
            sv = superview!
        }
        
        var beginXPos: CGFloat
        var endXPos: CGFloat
        
        var beginYPos: CGFloat
        var endYPos: CGFloat
        
        var xOffset: CGFloat
        var yOffset: CGFloat
        
        //Start object either L->R, L->R
        
        if arc4random_uniform(2) == 0 {
            beginXPos = CGFloat(-200)
            endXPos = (sv.bounds.width + 200)
            xOffset = CGFloat(arc4random_uniform(UInt32(superview!.bounds.width/3.0)))
        }else{
            beginXPos = (sv.bounds.width + 200)
            endXPos = CGFloat(-200)
            xOffset = -CGFloat(arc4random_uniform(UInt32(sv.bounds.width/3.0)))
        }
        
        //Start object either T->B, B->T
        
        beginYPos = CGFloat(arc4random_uniform(UInt32(sv.bounds.height)))
        endYPos = CGFloat(arc4random_uniform(UInt32(sv.bounds.height)))
        
        yOffset = CGFloat(arc4random_uniform(UInt32(sv.bounds.height/3.0)))
        
        if endYPos < beginYPos{
            yOffset = -yOffset
        }
        
        let color = arc4random_uniform(5)
        let duration = NSTimeInterval(arc4random_uniform(10-3) + 3)
        let objectHeight = CGFloat(arc4random_uniform(100-15) + 15)
        let objectWidthMultiplier = CGFloat(arc4random_uniform(200-100) + 100)
        let objectWidth = objectHeight * objectWidthMultiplier/100.0
        
        let test = UIView(frame: CGRect(x: beginXPos, y: beginYPos, width: objectWidth, height: objectHeight))
        test.tag = backgroundViewTag
        
        //Increment tag id.Reset if > 200
        if backgroundViewTag < 200{
            backgroundViewTag += 1
        }else{
            backgroundViewTag = 100
        }
        
        test.layer.cornerRadius = objectWidth/2
        test.layer.masksToBounds = true
        
        switch color{
        case 0:
            test.backgroundColor = UIColor.yellowColor()
        case 1:
            test.backgroundColor = UIColor.redColor()
        case 2:
            test.backgroundColor = UIColor.orangeColor()
        case 3:
            test.backgroundColor = UIColor.purpleColor()
        case 4:
            test.backgroundColor = UIColor.whiteColor()
        default:
            test.backgroundColor = UIColor.greenColor()
        }
        
        sv.insertSubview(test, atIndex: 0)
        
        let path = UIBezierPath()
        
        let startPoint = CGPoint(x: beginXPos, y: beginYPos)
        let endPoint = CGPoint(x: endXPos, y: endYPos)
        let controlPoint1 = CGPoint(x: beginXPos + xOffset , y: beginYPos + yOffset)
        let controlPoint2 = CGPoint(x: beginXPos + 2.0 * xOffset , y: beginYPos + 2.0 * yOffset)
        
        path.moveToPoint(startPoint)
        path.addCurveToPoint(endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        //Path Animation
        
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.setValue(test.tag, forKey: "position")
        anim.path = path.CGPath
        anim.rotationMode = kCAAnimationRotateAuto
        anim.repeatCount = 0
        anim.duration = duration
        anim.removedOnCompletion = true
        anim.delegate = self
        
        //Add Animation to Layer
        test.layer.addAnimation(anim, forKey: "animate position along path")
    }
}