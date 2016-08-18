//
//  SettingsViewController.swift
//  JackieMath2
//
//  Created by Mark Eaton on 4/9/15.
//  Copyright (c) 2015 Eaton Productions. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var settingsSwipe: UIGestureRecognizer!
    @IBOutlet var settingsSlider: UISlider!
    @IBOutlet var sliderLabel: UITextField!
    @IBOutlet var additionOperator: UISwitch!
    @IBOutlet var subtractionOperator: UISwitch!
    @IBOutlet var multiplicationOperator: UISwitch!
    @IBOutlet var divideOperator: UISwitch!
    @IBOutlet var negNumSwitch: UISwitch!
    @IBOutlet var negNumLabel: UILabel!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    
    var sliderKey: String = "SettingsViewController.sliderKey"
    var sliderLabelText: String {
        
        get {
            
            if let string1 = userDefaults.stringForKey(sliderKey) as String!
            {
                UpdateSlider(string1)
                return self.userDefaults.stringForKey(self.sliderKey)!
            }
            else
            {
                UpdateSlider("9")
                return "9"
            }
        }

        set(newValue) {
            
            UpdateSlider(newValue)
            self.userDefaults.setValue(newValue, forKey: self.sliderKey)
            self.userDefaults.synchronize()
        }
    }
    
    var additionSwitchKey: String = "SettingsViewController.additionSwitchKey"
    var additionSwitch: Bool {
        get {
            return self.userDefaults.boolForKey(additionSwitchKey)
        }
        set(newValue) {
            self.userDefaults.setBool(newValue, forKey: additionSwitchKey)
            self.userDefaults.synchronize()
        }
    }
    
    var subtractionSwitchKey: String = "SettingsViewController.subtractionSwitchKey"
    var subtractionSwitch: Bool {
        get {
            return self.userDefaults.boolForKey(subtractionSwitchKey)
        }
        set(newValue) {
            self.userDefaults.setBool(newValue, forKey: subtractionSwitchKey)
            self.userDefaults.synchronize()
        }
    }
    
    var multiplicationSwitchKey: String = "SettingsViewController.multiplicationSwitchKey"
    var multiplicationSwitch: Bool {
        get {
            return self.userDefaults.boolForKey(multiplicationSwitchKey)
        }
        set(newValue) {
            self.userDefaults.setBool(newValue, forKey: multiplicationSwitchKey)
            self.userDefaults.synchronize()
        }
    }
    
    var divideSwitchKey: String = "SettingsViewController.divideSwitchKey"
    var divideSwitch: Bool {
        get {
            return self.userDefaults.boolForKey(divideSwitchKey)
        }
        set(newValue) {
            self.userDefaults.setBool(newValue, forKey: divideSwitchKey)
            self.userDefaults.synchronize()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Create the Pinch Gesture Recognizer */
        screenEdgeRecognizer =  UIScreenEdgePanGestureRecognizer(target: self,
            action: "handleScreenEdgePan:")
        
        // Detect pans from right edge to the inside of the view */
        screenEdgeRecognizer.edges = .Right
        
    }

    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        //Add Screen Edge Pan
        view.addGestureRecognizer(screenEdgeRecognizer)
        
        SetTextFieldKeyBoard()
        SetUserDefaults()
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//        view.endEditing(true)
//        super.touchesBegan(touches as Set<NSObject>, withEvent: event)
//  
//        if sliderLabel.text == ""
//        {
//            print("space")
//            sliderLabel.text = "1"
//            sliderLabelText = sliderLabel.text!
//        }
//        else
//        {
//            sliderLabelText = sliderLabel.text!
//        }
//        
//        
//        
//    }

    @IBAction func ChangeSliderValue(sender: UISlider){
        
        sliderLabelText = String(Int(sender.value))
        sliderLabel.text = sliderLabelText
       
    }
    

    func UpdateSlider(sender: String){
        
        let float1 = Float(Int(sender)!)
        settingsSlider.setValue(float1, animated: true)
        
    }
    
    @IBAction func SwitchChange(sender: UISwitch) {
        
        switch sender.tag {
            
        case 1:
            
            additionSwitch = sender.on
            
        case 2:
            
            subtractionSwitch = sender.on
            
        case 3:
            
            multiplicationSwitch = sender.on
            
        case 4:
            
            divideSwitch = sender.on
            
        default: break
            
        }
        
    }
    
    func handleScreenEdgePan(gesture: UIScreenEdgePanGestureRecognizer){
        
        if gesture.state == .Ended {
            
            self.performSegueWithIdentifier("ShowParentalControlViewController", sender: nil)
            
        }
    }
    
    func SetUserDefaults()
        
    {
        sliderLabel.text = sliderLabelText
        additionOperator.on = additionSwitch
        subtractionOperator.on = subtractionSwitch
        multiplicationOperator.on = multiplicationSwitch
        divideOperator.on = divideSwitch
    }
    
    func SetTextFieldKeyBoard()
    {
        //Slider
        self.sliderLabel?.keyboardType = UIKeyboardType.NumberPad
    }
    
}