//
//  ParentalControlViewController.swift
//  JackieWWDC
//
//  Created by Mark Eaton on 6/10/15.
//  Copyright (c) 2015 Eaton Productions. All rights reserved.
//

import UIKit

class ParentalControlViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

   //MARK: - Outlets
    @IBOutlet weak var bonusSwitch: UISwitch!
    @IBOutlet weak var bonusLabel: UILabel!
    
    @IBOutlet weak var bonus1stNum: UITextField!
    @IBOutlet weak var bonus2ndNum: UITextField!
    @IBOutlet weak var bonusOperator: UITextField!
    @IBOutlet weak var triggerText: UITextField!
    
    @IBOutlet weak var prizeTitle: UITextField!
    @IBOutlet weak var prizeDescription: UITextField!
    @IBOutlet weak var prizeImage: UIImageView!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    
    //MARK: - Properties
    
    var bonusSwitchKey: String = "ParentalControlViewController.bonusSwitchKey"
    var bonusSwitchValue: Bool {
        get {
            return self.userDefaults.boolForKey(bonusSwitchKey)
        }
        set(newValue) {
            
            self.userDefaults.setBool(newValue, forKey: bonusSwitchKey)
            self.userDefaults.synchronize()
        }
    }
    
    var bonus1stNumKey: String = "ParentalControlViewController.bonus1stNumKey"
    var bonus1stNumValue: String {
        get {
            if let value = self.userDefaults.stringForKey(self.bonus1stNumKey) as String?{
                return value
            }else
            {
                return "5"
            }
        
        }
        set(newValue) {
            
            var value = newValue
            if newValue == ""
            {
                value = "1"
                bonus1stNum.text = value
            }else
            {
                value = newValue
            }
            
            self.userDefaults.setObject(value, forKey: bonus1stNumKey)
            self.userDefaults.synchronize()
        }
    }
    
    var bonus2ndNumKey: String = "ParentalControlViewController.bonus2ndNumKey"
    var bonus2ndNumValue: String {
        get{
            if let string = self.userDefaults.stringForKey(bonus2ndNumKey) as String? {
            return string
            }else
            {
                return "5"
            }
        }
        set(newValue) {
            
            var value = newValue
            if newValue == ""
            {
                value = "1"
                bonus2ndNum.text = value
            }else
            {
                value = newValue
            }
            
            self.userDefaults.setObject(value, forKey: bonus2ndNumKey)
            self.userDefaults.synchronize()
        }
    }
    
    var bonusOperatorKey: String = "ParentalControlViewController.bonusOperatorKey"
    var bonusOperatorValue: String {
        get
        {
            if let string = self.userDefaults.stringForKey(bonusOperatorKey)
            {
            return string
            } else{
                return "+"
            }
        }
        set(newValue)
        {
            var value = newValue
            if newValue == ""
            {
                value = "+"
                bonusOperator.text = value
            }else
            {
                value = newValue
            }
           
            self.userDefaults.setObject(value, forKey: bonusOperatorKey)
            self.userDefaults.synchronize()
        }
    }
    
    var triggerTextKey: String = "ParentalControlViewController.triggerTextKey"
    var triggerTextValue: String {
        get
        {
            if let string = self.userDefaults.stringForKey(triggerTextKey)
            {
                return string
            } else{
                return "0"
            }
        }
        set(newValue)
        {
            var value = newValue
            if newValue == ""
            {
                value = "1"
                triggerText.text = value
            }else
            {
                value = newValue
            }
            self.userDefaults.setObject(value, forKey: triggerTextKey)
            self.userDefaults.synchronize()
        }
    }
    
    var prizeTitleKey: String = "ParentalControlViewController.prizeTitleKey"
    var prizeTitleValue: String {
        get
        {
            if let string = self.userDefaults.stringForKey(prizeTitleKey)
            {
                return string
            } else{
                return "Enter Prize Title"
            }
        }
        set(newValue)
        {
            var value = newValue
            if newValue == ""
            {
                value = "Enter Prize Title"
                prizeTitle.text = value
            }else
            {
                value = newValue
            }

            self.userDefaults.setObject(value, forKey: prizeTitleKey)
            self.userDefaults.synchronize()
        }
    }
    
    var prizeDescriptionKey: String = "ParentalControlViewController.prizeDescriptionKey"
    var prizeDescriptionValue: String {
        get
        {
            if let string = self.userDefaults.stringForKey(prizeDescriptionKey)
            {
                return string
            } else{
                return "Enter Prize Description"
            }
        }
        set(newValue)
        {
            var value = newValue
            if newValue == ""
            {
                value = "Enter Prize Description"
                prizeDescription.text = value
            }else
            {
                value = newValue
            }

            self.userDefaults.setObject(value, forKey: prizeDescriptionKey)
            self.userDefaults.synchronize()
        }
    }
    
    var prizeImagePathKey: String = "ParentalControlViewController.prizeImageKey"
    var prizeImagePathValue: String {
        get
        {
            if let string = self.userDefaults.stringForKey(prizeImagePathKey)
            {
                return string
            } else{
                return "Enter Prize Description"
            }
        }
        set(newValue)
        {
            self.userDefaults.setObject(newValue, forKey: prizeImagePathKey)
            self.userDefaults.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetUserDefaults()
        SetTextFieldKeyBoards()
        AddTapGestureToImage()
        getPrizeImage()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func SwitchChange(sender: UISwitch) {
        
        bonusSwitchValue = sender.on
        
    }
    
   
    @IBAction func TextFieldChange(sender: UITextField) {
        
        switch sender.tag{
            
        case 1:
            bonus1stNumValue = sender.text!
        case 2:
            bonus2ndNumValue = sender.text!
        case 3:
            bonusOperatorValue = sender.text!
        case 4:
            triggerTextValue = sender.text!
        case 5:
            prizeTitleValue = sender.text!
        case 6:
            prizeDescriptionValue = sender.text!
        default: break
            
        }
    }

    
    func SetUserDefaults()
    {
        
        bonusSwitch.on = bonusSwitchValue
        bonus1stNum.text = bonus1stNumValue
        bonus2ndNum.text = bonus2ndNumValue
        bonusOperator.text = bonusOperatorValue
        triggerText.text = triggerTextValue
        
        prizeTitle.text = prizeTitleValue
        prizeDescription.text = prizeDescriptionValue
        
        
    }
    
    func SetTextFieldKeyBoards()
    {
        //Set TextField Keyboards
        
        self.bonus1stNum.keyboardType = UIKeyboardType.NumberPad
        self.bonus2ndNum.keyboardType = UIKeyboardType.NumberPad
        self.triggerText.keyboardType = UIKeyboardType.NumberPad
        self.bonusOperator.keyboardType = UIKeyboardType.NumbersAndPunctuation
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        view.endEditing(true)
//        super.touchesBegan(touches as Set<NSObject>, withEvent: event)
//    }
    
    func tappedMe() {
    
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
        
        let gotImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        prizeImage.image = gotImage
        
        //save image to user defaults
        
        let imagedata = UIImageJPEGRepresentation(gotImage!, 1)!
        prizeImagePathValue = "image_\(NSDate.timeIntervalSinceReferenceDate()).jpg"
        let path = self.documentsPathForFileName(prizeImagePathValue)
        
        imagedata.writeToFile(path, atomically: true)
        
    }
    
    func documentsPathForFileName(name: String) -> String {
        
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let path = paths[0] as String
//        let fullPath = path.stringByAppendingPathComponent(name)
        
        // Not Tested - 11/1/2015
        
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let path1 = paths.URLByAppendingPathComponent(name)
        let fullPath = path1.path!
        
        return fullPath
    }
    
    func getPrizeImage() {
        
        let possibleOldImagePath = prizeImagePathValue as String?
        if let oldImagePath = possibleOldImagePath {
            
            let oldFullPath = self.documentsPathForFileName(oldImagePath)
            let oldImageData = NSData(contentsOfFile: oldFullPath)
            
            if oldImageData != nil
            {
                let oldImage = UIImage(data: oldImageData!)
                prizeImage.image = oldImage
            }
        }
    }
    
    func AddTapGestureToImage()
    {
        let tap = UITapGestureRecognizer(target: self, action: Selector("tappedMe"))
        prizeImage.addGestureRecognizer(tap)
        prizeImage.userInteractionEnabled = true
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
