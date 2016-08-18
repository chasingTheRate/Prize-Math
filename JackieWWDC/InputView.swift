//
//  InputView.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/12/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit


protocol InputViewDelegate: NSObjectProtocol{
    func changeAnswer(sender: String)
}

class InputView: UIView {

    var buttonBorderColor = UIColor.whiteColor()
    var buttonBackgroundColor = UIColor.whiteColor()
    var vibrancyEffectView: UIVisualEffectView!
    var blurEffectStyle: UIBlurEffectStyle = .Dark
    var longPress: UILongPressGestureRecognizer!
    var longPressOn = false
    
    var viewCollection: [UIVisualEffectView] = []
    private var labelCollection: [UILabel] = []
    //var originalButtonCenters: [CGPoint] = []
    var delegate: InputViewDelegate?
    var buttonLocationsSet = false

    //Vibrancy Views
    
    var nineView = UIVisualEffectView()
    var eightView = UIVisualEffectView()
    var sevenView = UIVisualEffectView()
    var sixView = UIVisualEffectView()
    var fiveView = UIVisualEffectView()
    var fourView = UIVisualEffectView()
    var threeView = UIVisualEffectView()
    var twoView = UIVisualEffectView()
    var oneView = UIVisualEffectView()
    var zeroView = UIVisualEffectView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
    
        }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        //Clear Collections
        
        viewCollection.removeAll()
        labelCollection.removeAll()
        
        //Clear Subviews
        for view in self.subviews{
            view.removeFromSuperview()
        }
        
        //Create Views
        
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: blurEffectStyle))
        vibrancyEffectView = UIVisualEffectView(effect: nil)
        
        //Required for Contraints
        
        nineView = UIVisualEffectView(effect: vibrancyEffect)
        eightView = UIVisualEffectView(effect: vibrancyEffect)
        sevenView = UIVisualEffectView(effect: vibrancyEffect)
        sixView = UIVisualEffectView(effect: vibrancyEffect)
        fiveView = UIVisualEffectView(effect: vibrancyEffect)
        fourView = UIVisualEffectView(effect: vibrancyEffect)
        threeView = UIVisualEffectView(effect: vibrancyEffect)
        twoView = UIVisualEffectView(effect: vibrancyEffect)
        oneView = UIVisualEffectView(effect: vibrancyEffect)
        zeroView = UIVisualEffectView(effect: vibrancyEffect)
        
        self.addSubview(zeroView)
        self.addSubview(oneView)
        self.addSubview(twoView)
        self.addSubview(threeView)
        self.addSubview(fourView)
        self.addSubview(fiveView)
        self.addSubview(sixView)
        self.addSubview(sevenView)
        self.addSubview(eightView)
        self.addSubview(nineView)
        
        var count = 0
        
        for view in self.subviews{
            
            let visualView = view as? UIVisualEffectView
            let button = UIButton()
            let label = UILabel()
            
            //Format View
            visualView?.translatesAutoresizingMaskIntoConstraints = false
            visualView?.backgroundColor = UIColor.clearColor()
            visualView?.tag = count
            //visualView?.layer.masksToBounds = true
            
            //Format Label
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Futura-Medium", size: 25.0)
            label.tag = count
            label.text = count.description
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
        
            //Format Button
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = count
            button.layer.masksToBounds = true
            button.layer.borderColor = buttonBorderColor.CGColor
            button.layer.borderWidth = 2.0
            
            button.addTarget(self, action: #selector(buttonPressed), forControlEvents: .TouchUpInside)
            button.addTarget(self, action: #selector(buttonTouchDown), forControlEvents: .TouchDown)
            button.addTarget(self, action: #selector(resetButtonBackgroundColor), forControlEvents: .TouchCancel)
            button.addTarget(self, action: #selector(resetButtonBackgroundColor), forControlEvents: .TouchDragOutside)
            button.addTarget(self, action: #selector(resetButtonBackgroundColor), forControlEvents: .TouchUpOutside)
            
            if view.tag == 0{
                button.addGestureRecognizer(longPress)
            }
            
            count += 1
            
            //Add Subviews
            
            visualView?.contentView.addSubview(button)
            visualView?.addSubview(label)
            
            if visualView != nil{
                viewCollection.append(visualView!)
                labelCollection.append(label)
            }
            
        }

        let heightSpacingToButtonHeightRatio: CGFloat = 0.25
        let widthSpacingToButtonHeightRatio: CGFloat = 0.40
        
        let buttonHeight = getButtonHeight(bounds.height, ratio: heightSpacingToButtonHeightRatio)
        let heightSpacing = buttonHeight * heightSpacingToButtonHeightRatio
        let widthSpacing = buttonHeight * widthSpacingToButtonHeightRatio
        let topPadding = (bounds.height - (buttonHeight * 4.0) - (heightSpacing * 3.0))/2
        
        //Remove Constaints from Superview
        removeConstraints(constraints)
        
        //Add Button Contraints
        
        var visualViewContraints: [NSLayoutConstraint] = []
        var viewContraints: [NSLayoutConstraint] = []
        var buttonConstraints: [NSLayoutConstraint] = []
        var labelConstraints: [NSLayoutConstraint] = []
    
        for visualView in viewCollection{
            
            //Remove any existing contraints
            
            visualView.removeConstraints(visualView.constraints)
            let button = visualView.contentView.subviews.first! as! UIButton
            let label = visualView.subviews.last! as! UILabel
            
            button.removeConstraints(button.constraints)
            label.removeConstraints(label.constraints)
            
            switch visualView.tag{
                
            case 8:
                let centerXConstraint = NSLayoutConstraint(item: visualView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
                let topConstaint = NSLayoutConstraint(item: visualView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: topPadding)
                viewContraints.append(centerXConstraint)
                viewContraints.append(topConstaint)
            case 5:
                let centerXConstraint = NSLayoutConstraint(item: visualView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
                let topConstaint = NSLayoutConstraint(item: visualView, attribute: .Top, relatedBy: .Equal, toItem: eightView, attribute: .Bottom, multiplier: 1.0, constant: heightSpacing)
                viewContraints.append(centerXConstraint)
                viewContraints.append(topConstaint)
            case 2:
                let centerXConstraint = NSLayoutConstraint(item: visualView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
                let topConstaint = NSLayoutConstraint(item: visualView, attribute: .Top, relatedBy: .Equal, toItem: fiveView, attribute: .Bottom, multiplier: 1.0, constant: heightSpacing)
                viewContraints.append(centerXConstraint)
                viewContraints.append(topConstaint)
            case 0:
                let centerXConstraint = NSLayoutConstraint(item: visualView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
                let topConstaint = NSLayoutConstraint(item: visualView, attribute: .Top, relatedBy: .Equal, toItem: twoView, attribute: .Bottom, multiplier: 1.0, constant: heightSpacing)
                viewContraints.append(centerXConstraint)
                viewContraints.append(topConstaint)
            case 9:
                let centerXConstraint = NSLayoutConstraint(item: visualView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: widthSpacing + buttonHeight)
                let topConstaint = NSLayoutConstraint(item: visualView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: topPadding)
                viewContraints.append(centerXConstraint)
                viewContraints.append(topConstaint)
            case 6:
                let centerXConstraint = NSLayoutConstraint(item: visualView, attribute: .CenterX, relatedBy: .Equal, toItem: eightView, attribute: .CenterX, multiplier: 1.0, constant: widthSpacing + buttonHeight)
                let centerYConstraint = NSLayoutConstraint(item: visualView, attribute: .CenterY, relatedBy: .Equal, toItem: fiveView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
                viewContraints.append(centerXConstraint)
                viewContraints.append(centerYConstraint)
            case 3:
                let centerXConstraint = NSLayoutConstraint(item: visualView, attribute: .CenterX, relatedBy: .Equal, toItem: nineView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
                let centerYConstraint = NSLayoutConstraint(item: visualView, attribute: .CenterY, relatedBy: .Equal, toItem: twoView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
                viewContraints.append(centerXConstraint)
                viewContraints.append(centerYConstraint)
            case 7:
                let centerXConstraint = NSLayoutConstraint(item: visualView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: -(widthSpacing + buttonHeight))
                let topConstaint = NSLayoutConstraint(item: visualView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: topPadding)
                viewContraints.append(centerXConstraint)
                viewContraints.append(topConstaint)
            case 4:
                let centerXConstraint = NSLayoutConstraint(item: visualView, attribute: .CenterX, relatedBy: .Equal, toItem: sevenView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
                let centerYConstraint = NSLayoutConstraint(item: visualView, attribute: .CenterY, relatedBy: .Equal, toItem: fiveView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
                viewContraints.append(centerXConstraint)
                viewContraints.append(centerYConstraint)
            case 1:
                let centerXConstraint = NSLayoutConstraint(item: visualView, attribute: .CenterX, relatedBy: .Equal, toItem: sevenView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
                let centerYConstraint = NSLayoutConstraint(item: visualView, attribute: .CenterY, relatedBy: .Equal, toItem: twoView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
                viewContraints.append(centerXConstraint)
                viewContraints.append(centerYConstraint)
            default:
                break
            }
            
            //Define Constaints between Button and View, Label & View
            
            let buttonCenterXConstraint = NSLayoutConstraint(item: button, attribute: .CenterX, relatedBy: .Equal, toItem: visualView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
            
            let buttonCenterYConstraint = NSLayoutConstraint(item: button, attribute: .CenterY, relatedBy: .Equal, toItem: visualView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
            
            let labelCenterXConstraint = NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: visualView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
            
            let labelCenterYConstraint = NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: visualView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
            
            visualViewContraints.append(buttonCenterXConstraint)
            visualViewContraints.append(buttonCenterYConstraint)
            visualViewContraints.append(labelCenterXConstraint)
            visualViewContraints.append(labelCenterYConstraint)
            
            //Define Height and Width Constraints for View, Button, Label
            
            let heightConstraint = NSLayoutConstraint(item: visualView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonHeight)
            let widthConstraint = NSLayoutConstraint(item: visualView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonHeight)
            
            let buttonHeightConstraint = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonHeight)
            let buttonWidthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonHeight)
            
            let labelHeightConstraint = NSLayoutConstraint(item: label, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonHeight)
            let labelWidthConstraint = NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonHeight)
            
            visualViewContraints.append(heightConstraint)
            visualViewContraints.append(widthConstraint)
            
            buttonConstraints.append(buttonHeightConstraint)
            buttonConstraints.append(buttonWidthConstraint)
            
            labelConstraints.append(labelHeightConstraint)
            labelConstraints.append(labelWidthConstraint)
            
            //Add Constaints to Superview, View, Button & Label
            
            button.addConstraints(buttonConstraints)
            label.addConstraints(labelConstraints)
            visualView.addConstraints(visualViewContraints)
            self.addConstraints(viewContraints)
            
            //Round Corners
            button.layer.cornerRadius = buttonHeight/2
            visualView.layer.cornerRadius = buttonHeight/2
        
            //Clear [Contraints]
            visualViewContraints.removeAll()
            viewContraints.removeAll()
            buttonConstraints.removeAll()
            labelConstraints.removeAll()
            
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
                let touchPoint = touch.locationInView(self)
        
                for view in viewCollection{
                    if ((view.layer.presentationLayer()?.hitTest(touchPoint)) != nil){
                        animationButtonTouchDown(view)
                        delegate?.changeAnswer(view.contentView.subviews.first!.tag.description)
            }
        }
    }
    
    override func  touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Do Nothing??
    }
    
    
    func getButtonHeight(viewHeight: CGFloat, ratio: CGFloat) -> CGFloat{

        let numberOfButtons: CGFloat = 4.0
        let numberOfSpaces: CGFloat = numberOfButtons + 1.0
        let maxButtonHeight: CGFloat = 70.0

        let buttonWidth = (viewHeight)/(numberOfButtons + numberOfSpaces * ratio)
        
        if buttonWidth < maxButtonHeight{
            return buttonWidth
        }else{
            return maxButtonHeight
        }
    }
    
    func buttonPressed(sender: UIButton!){
        
        let text: String
        
        resetButtonBackgroundColor(sender)
        if longPressOn{
            let superview = sender.superview?.superview
            let label = superview?.subviews.last as! UILabel
            text = label.text!
        }else{
            text = sender.tag.description
        }
        delegate?.changeAnswer(text)
    }
    
    func buttonTouchDown(sender: UIButton){
        
        let duration1: NSTimeInterval = 0.1
        let duration2: NSTimeInterval = 0.50
        let delay: NSTimeInterval = 0.0
        let animationOptions: UIViewAnimationOptions = [.AllowUserInteraction]
        
        UIView.animateWithDuration(duration1, delay: delay, options: animationOptions, animations: {
            sender.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.6)
            }, completion: {finished in
                //Reverse Animation
                UIView.animateWithDuration(duration2, delay: delay, options: animationOptions, animations: {
                    
                    //sender.backgroundColor = UIColor.clearColor()
                    
                    }, completion: nil)
        })
    }
    
    func resetButtonBackgroundColor(sender: UIButton!){
        
        let duration2: NSTimeInterval = 0.50
        let delay: NSTimeInterval = 0.0
        let animationOptions: UIViewAnimationOptions = [.AllowUserInteraction]
        
        UIView.animateWithDuration(duration2, delay: delay, options: animationOptions, animations: {
            sender.backgroundColor = UIColor.clearColor()
            }, completion: nil)
    }
    
    
    func animationButtonTouchDown(sender: UIView){
    
        let duration1: NSTimeInterval = 0.1
        let duration2: NSTimeInterval = 0.50
        let delay: NSTimeInterval = 0.0
        let animationOptions: UIViewAnimationOptions = [.AllowUserInteraction]
        
        UIView.animateWithDuration(duration1, delay: delay, options: animationOptions, animations: {
            sender.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.15)
            }, completion: {finished in
                //Reverse Animation
                UIView.animateWithDuration(duration2, delay: delay, options: animationOptions, animations: {
                    sender.backgroundColor = UIColor.clearColor()
                    }, completion: nil)})
    }
    
    func longPressed(sender: UILongPressGestureRecognizer){
        
        switch sender.state{
        case .Began:
            
            if !longPressOn{
                longPressOn = true
                
                var newLabelText: String!
                
                for label in labelCollection{
                    switch label.tag{
                    case 0:
                        newLabelText = "-"
                    case 1:
                        newLabelText = "/"
                    case 2:
                        newLabelText = "."
                    default:
                        newLabelText = ""
                    }
                    
                    UIView.transitionWithView(label.superview!, duration: 0.50, options: .TransitionFlipFromBottom, animations: {
                        label.text = newLabelText
                        }, completion: nil)
                }
            }else{
                longPressOn = false
                var newLabelText: String!
                
                for label in labelCollection{
                    newLabelText = label.tag.description
                    UIView.transitionWithView(label.superview!, duration: 0.50, options: .TransitionFlipFromBottom, animations: {
                        label.text = newLabelText
                        }, completion: nil)
                }
            }
            
        default:
            break
        }
    }
}
