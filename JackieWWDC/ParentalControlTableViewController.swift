//
//  ParentalControlTableViewController.swift
//  JackieWWDC
//
//  Created by Mark Eaton on 6/28/15.
//  Copyright © 2015 Eaton Productions. All rights reserved.
//

import UIKit

class ParentalControlTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

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
    
    @IBOutlet var parentalControlTableView: UITableView!
    @IBOutlet weak var setBonusQuestionView: UIView!
    
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
            if value == ""
            {
                value = "0"
                bonus1stNum.text = value
            }else
            {
                bonus1stNum.text = value
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
            if value == ""
            {
                value = "0"
                bonus2ndNum.text = value
            }else
            {
                bonus2ndNum.text = value
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
            if value == ""
            {
                value = "+"
                bonusOperator.text = value
            }else
            {
                bonusOperator.text = value
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
            if value == ""
            {
                value = "1"
                triggerText.text = value
            }else
            {
                triggerText.text = value
            }
            self.userDefaults.setObject(value, forKey: triggerTextKey)
            self.userDefaults.synchronize()
            print(value)
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
            if value == ""
            {
                value = "Enter Prize Title"
                prizeTitle.text = value
                
            }else
            {
                prizeTitle.text = value
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
            if value == ""
            {
                value = "Enter Prize Description"
                prizeDescription.text = value
            }else
            {
                prizeDescription.text = value
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
    
    //MARK: -View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UpdateUI()
        //SetUserDefaults()
        AddTapGestureToImage()
        getPrizeImage()

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        parentalControlTableView.delegate = self
        parentalControlTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func SwitchChange(sender: UISwitch) {
        
        bonusSwitchValue = sender.on
        
        if sender.on{
            bonusLabel.text = "ON"
        }else{
            bonusLabel.text = "OFF"
        }
        
    }
    
    @IBAction func TxtFieldTouchUpInside(sender: UITextField) {
        if sender.text == "Enter Prize Title" || sender.text == "Enter Prize Description" {
            sender.text = ""
        }
        
    }
    func UpdateUI()
    {
        //bonus1stNum.delegate = self
        //bonus2ndNum.delegate = self
        //bonusOperator.delegate = self
        prizeDescription.delegate = self
        prizeTitle.delegate = self
        //triggerText.delegate = self
        

        
        //Round Image Corners and add border
        
        prizeImage.layer.cornerRadius = 50
        prizeImage.layer.masksToBounds = true
        
        prizeImage.layer.borderColor = UIColor(red: 224/255, green: 45/255, blue: 126/255, alpha: 1.0).CGColor
        prizeImage.layer.borderWidth = 3
        
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
        
        if bonusSwitchValue{
            bonusLabel.text="ON"
        }else{
            bonusLabel.text="OFF"
        }
        
        
    }
    
    func tappedMe() {
        
        let pictureOption = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .Default, handler: {
             (alert: UIAlertAction!) -> Void in
            print("Take Photo")
            })
        
        let selectPhoto = UIAlertAction(title: "Select Photo", style: .Default, handler: {
        (alert: UIAlertAction!) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        pictureOption.addAction(takePhoto)
        pictureOption.addAction(selectPhoto)
        pictureOption.addAction(cancelAction)
        
        self.presentViewController(pictureOption, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        
        var imageData: NSData

        self.dismissViewControllerAnimated(true, completion: nil);
        
        var gotImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //Square Image
        
        gotImage = RBSquareImage(gotImage!)

        let newSize = CGSize(width: 200,height: 200)
        let newRect = CGRect(x: 0, y: 0, width: newSize.height, height: newSize.width)
        
        UIGraphicsBeginImageContext(newSize)
        gotImage!.drawInRect(newRect)
        gotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Compress Image
        
        imageData = UIImageJPEGRepresentation(gotImage!, 1)!
        //reducedImage = UIImage(data: imageData)!

        prizeImage.image = gotImage!
        
        //save image to user defaults
        
        prizeImagePathValue = "image_\(NSDate.timeIntervalSinceReferenceDate()).jpg"
        let path = self.documentsPathForFileName(prizeImagePathValue)
        
        imageData.writeToFile(path, atomically: true)
        
    }
    
    func documentsPathForFileName(name: String) -> String {
    
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
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        switch textField.tag{
            
        case 1:
            bonus1stNumValue = textField.text!
        case 2:
            bonus2ndNumValue = textField.text!
        case 4:
            triggerTextValue = textField.text!
        case 5:
            prizeTitleValue = textField.text!
        case 6:
            prizeDescriptionValue = textField.text!
        default: break
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("test")
        self.performSegueWithIdentifier("sequeShowSetBonusQuestion", sender: self)
        
    }


    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func RBSquareImage(image: UIImage) -> UIImage {
        let originalWidth  = image.size.width
        let originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        let posX = (originalWidth  - edge) / 2.0
        let posY = (originalHeight - edge) / 2.0
        
        let cropSquare = CGRectMake(posX, posY, edge, edge)
        
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
        return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if textField.tag == 3{
            ShowOperatorActionSheet()
            return false
        }else{
            return true
        }
    }
    
    //MARK: Action Sheets
    
    func ShowOperatorActionSheet()
    {
        let operatorOption = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let addition = UIAlertAction(title: "+", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.bonusOperator.text = "+"
        })
        
        let subtraction = UIAlertAction(title: "-", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.bonusOperator.text = "-"
        })
        
        let multiply = UIAlertAction(title: "×", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.bonusOperator.text = "×"
        })
        
        let divide = UIAlertAction(title: "÷", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.bonusOperator.text = "÷"
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        operatorOption.addAction(addition)
        operatorOption.addAction(subtraction)
        operatorOption.addAction(multiply)
        operatorOption.addAction(divide)
        operatorOption.addAction(cancelAction)
        
        self.presentViewController(operatorOption, animated: true, completion: nil)
    }
}
