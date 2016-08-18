//
//  PasscodeViewController.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/3/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit
import AudioToolbox

@objc protocol PassCodeViewControllerDelegate {
    func testDelegate()
}

class PasscodeViewController: UIViewController, UITextFieldDelegate {

    let colors = Colors()
    let users = UserDefaults()
    
    @IBOutlet weak var passCodeLabel: UILabel!
    
    @IBOutlet weak var passCodeTextField1: UITextField!
    @IBOutlet weak var passCodeTextField2: UITextField!
    @IBOutlet weak var passCodeTextField3: UITextField!
    @IBOutlet weak var passCodeTextField4: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var passcodeView: UIView!
    
    var settingPasscode = false
    var confirmingPasscode = false
    var passcodeIsSet = false
    var passcodeIsOn = false
    var savedPasscode: String?
    var confirmedPasscode: String?
    var nightMode = false
    var setPasscode: Bool = false
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserDefaults()
        
        view.backgroundColor = UIColor.clearColor()
        view.opaque = false
        
        //Set Delegates
        
        passCodeTextField1.delegate = self
        passCodeTextField2.delegate = self
        passCodeTextField3.delegate = self
        passCodeTextField4.delegate = self
    
        //Add Blur Effect
        
        addBlur()
        
        if setPasscode{
            settingPasscode = true
            passCodeLabel.text = "SET PASSCODE"
        }
    
        //Start Editing when View Loads
        textFieldDidBeginEditing(passCodeTextField1)

    }
    

    //MARK: TextFeild Functions
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if nightMode{
            textField.keyboardAppearance = .Dark
        }else{
            textField.keyboardAppearance = .Light
        }
        
        textField.becomeFirstResponder()
    }
    
    func getNextTextField(tag: Int) -> UITextField?{
        
        switch tag{
        case 1:
            return passCodeTextField2
        case 2:
            return passCodeTextField3
        case 3:
            return passCodeTextField4
        case 4:
            
            if settingPasscode{
                
                if confirmingPasscode{
                    
                    confirmingPasscode = false
                    confirmedPasscode = (passCodeTextField1.text! + passCodeTextField2.text! + passCodeTextField3.text! + passCodeTextField4.text!)
                    
                    if confirmedPasscode == savedPasscode{
                        
                        passCodeLabel.text = "CONFIRMED"
                        passcodeIsSet = true
                        setUserDefaults()
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    }else{
                        
                        passCodeLabel.text = "ERROR! TRY AGAIN."
                        
                        //Vibrate Phone
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                        
                        animateWrongPasscode()
                        resetTextFields()
                        confirmingPasscode = false
                    }
                    
                }else{
                    
                    confirmingPasscode = true
                    savedPasscode = (passCodeTextField1.text! + passCodeTextField2.text! + passCodeTextField3.text! + passCodeTextField4.text!)
                    
                    resetTextFields()
                    passCodeLabel.text = "CONFIRM PASSCODE"
                }
            }else{
                
                confirmedPasscode = (passCodeTextField1.text! + passCodeTextField2.text! + passCodeTextField3.text! + passCodeTextField4.text!)
            
                if confirmedPasscode == savedPasscode && savedPasscode != nil{
                    performSeguetoParentalController()
                }else{
                    
                    //Vibrate Phone
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    animateWrongPasscode()
                    resetTextFields()
                }
            }
            
            resignFirstResponder()
            return nil
            
        default:
            
            return nil
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    @IBAction func textFieldEditingDidChange(sender: UITextField) {
        
        sender.textColor = colors.secondaryColor[0]
        
        if let nextTextField = getNextTextField(sender.tag){
            textFieldDidBeginEditing(nextTextField)
        }else{
            textFieldDidBeginEditing(passCodeTextField1)
        }
    }
    
    @IBAction func cancelPasscodeInput(sender: AnyObject) {
        
        resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func addBlur(){
        
        let blur:UIBlurEffect?
        
        if nightMode{
            blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        }else{
            blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        }
    
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = subView.bounds
        subView.addSubview(blurView)
    }
    
    func resetTextFields(){
        
        passCodeTextField1.text? = "1"
        passCodeTextField1.textColor = colors.primaryColor[0]
        
        passCodeTextField2.text? = "1"
        passCodeTextField2.textColor = colors.primaryColor[0]
        
        passCodeTextField3.text? = "1"
        passCodeTextField3.textColor = colors.primaryColor[0]
        
        passCodeTextField4.text? = "1"
        passCodeTextField4.textColor = colors.primaryColor[0]
    }
    
    func performSeguetoParentalController(){
        
        resignFirstResponder()
        
        let test = self.presentingViewController as! PrizeTableViewController
        
        self.dismissViewControllerAnimated(true, completion: {finished in test.performSegueWithIdentifier("showParentalControl", sender: nil)})
        
    }
    
    //MARK: User Defaults
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    
    func getUserDefaults(){
        
        //Password Set?
        
        passcodeIsSet = userDefaults.boolForKey(UserDefaults.key.passcodeSet.rawValue)
        
        //Passcode
        
        if let value = userDefaults.stringForKey(UserDefaults.key.passcode.rawValue){
            savedPasscode = value
        }else{
            savedPasscode = nil
        }
    }
    
    func setUserDefaults(){
        
        //Passcode
        
        userDefaults.setObject(savedPasscode, forKey: UserDefaults.key.passcode.rawValue)
        userDefaults.setBool(passcodeIsSet, forKey: UserDefaults.key.passcodeSet.rawValue)
    }
    
    func animateWrongPasscode(){
        
        let orgCenter: CGPoint = passcodeView.center
        let dur1: NSTimeInterval = 0.1
        let dur2: NSTimeInterval = 0.1
        let dur3: NSTimeInterval = 0.1
        
        print(orgCenter.x.description)
        
        passcodeView.center = orgCenter
        
        
        UIView.animateWithDuration(dur1, delay: 0.0, options: [], animations: {
            self.passcodeView.transform = CGAffineTransformMakeTranslation(-30,0)}, completion: {finished in UIView.animateWithDuration(dur2, delay: 0.0, options: [], animations: {self.passcodeView.transform = CGAffineTransformMakeTranslation(30,0)}, completion: {finished in UIView.animateWithDuration(dur3, delay: 0.0, options: [], animations: {self.passcodeView.transform = CGAffineTransformMakeTranslation(0,0)}, completion: nil)})})
    }

}
