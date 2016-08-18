

import UIKit

class OldParentalControlViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var testButton: UIButton!
    
    @IBOutlet var shmqSwitch: UISwitch!
    @IBOutlet var shmqLabel: UILabel!
    @IBOutlet var shmq1stNum: UITextField!
    @IBOutlet var shmq2ndNum: UITextField!
    @IBOutlet var shmqOperator: UITextField!
    
    @IBOutlet var triggerText: UITextField!
    
    @IBOutlet var shmqTitle: UITextField!
    @IBOutlet var shmqDescription: UITextField!
    
    @IBOutlet var rewardImage: UIImageView!
    
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!

    func handleScreenEdgePan(sender: UIScreenEdgePanGestureRecognizer){
        
        if sender.state == .Ended{
        
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Create the Pinch Gesture Recognizer */
        screenEdgeRecognizer =  UIScreenEdgePanGestureRecognizer(target: self,
            action: "handleScreenEdgePan:")
        
        // Detect pans from left edge to the inside of the view */
        screenEdgeRecognizer.edges = .Left
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set User Defaults
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userDefaults.stringForKey("shmq1st") == nil {
        
            shmq1stNum.text = "1"
        
        } else {
            
            shmq1stNum.text = userDefaults.stringForKey("shmq1st")
        }
        
        if userDefaults.stringForKey("shmq2nd") == nil {
            
            shmq2ndNum.text = "1"
            
        } else {
            
            shmq2ndNum.text = userDefaults.stringForKey("shmq2nd")
        }
        
        if userDefaults.stringForKey("shmqOperator") == nil {
            
            shmqOperator.text = "+"
            
        } else {
            
            shmqOperator.text = userDefaults.stringForKey("shmqOperator")
        }
        
        if userDefaults.stringForKey("triggerText") == nil {
            
            triggerText.text = "1"
            
        } else {
            
            triggerText.text = userDefaults.stringForKey("triggerText")
        }
        
        if userDefaults.stringForKey("shmqTitle") != nil {
            
            shmqTitle.text = userDefaults.stringForKey("shmqTitle")
        }
        
        if userDefaults.stringForKey("shmqDescription") != nil {
            
            shmqDescription.text = userDefaults.stringForKey("shmqDescription")
        }
        
        
        shmqSwitch.on = userDefaults.boolForKey("shmqSwitch")
        HandleSwitch(shmqSwitch)
        
        //Set TextField Keyboards
        self.shmq1stNum.keyboardType = UIKeyboardType.NumberPad
        self.shmq2ndNum.keyboardType = UIKeyboardType.NumberPad
        self.triggerText.keyboardType = UIKeyboardType.NumberPad
        self.shmqOperator.keyboardType = UIKeyboardType.NumbersAndPunctuation
        
        view.addGestureRecognizer(screenEdgeRecognizer)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("tappedMe"))
        rewardImage.addGestureRecognizer(tap)
        rewardImage.userInteractionEnabled = true
        
        getPhoto()
        
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//        view.endEditing(true)
//        super.touchesBegan(touches as Set<NSObject>, withEvent: event)
//        
//        if shmqOperator.text == "*" {
//            
//            shmqOperator.text = "×" //÷×
//            
//        }else if shmqOperator.text == "/" {
//            
//            shmqOperator.text = "÷"
//            
//        }
//        
//        if shmqOperator.text != "×" && shmqOperator.text != "÷" && shmqOperator.text != "+" && shmqOperator.text != "-" {
//            
//            shmqOperator.text = "+"
//        }
//        
//        if triggerText.text == "" || triggerText.text < "1" {
//            
//            triggerText.text = "1"
//        }
//        
//        
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        
//        userDefaults.setObject(shmq1stNum.text, forKey: "shmq1st")
//        userDefaults.setObject(shmq2ndNum.text, forKey: "shmq2nd")
//        userDefaults.setObject(shmqOperator.text, forKey: "shmqOperator")
//        userDefaults.setObject(triggerText.text, forKey: "triggerText")
//        
//        userDefaults.setObject(shmqTitle.text, forKey: "shmqTitle")
//        userDefaults.setObject(shmqDescription.text, forKey: "shmqDescription")
//        
//        print("testy")
//        
//        
//    }
    
    @IBAction func HandleSwitch(sender: UISwitch) {
        
        if sender.on {
            
            shmqLabel.text = "ON"
        }
        
        else {
            
            shmqLabel.text = "OFF"
        }
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setObject(shmqSwitch.on, forKey: "shmqSwitch")
        
    }
    
    func tappedMe() {
        
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        self.presentViewController(pickerC, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
       
        self.dismissViewControllerAnimated(true, completion: nil);
    
        let gotImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        rewardImage.image = gotImage
        
        //save image to user defaults
        
        let imagedata = UIImageJPEGRepresentation(gotImage!, 1)
        let relativePath = "image_\(NSDate.timeIntervalSinceReferenceDate()).jpg"
        let path = self.documentsPathForFileName(relativePath)
        
        imagedata!.writeToFile(path, atomically: true)
        
        NSUserDefaults.standardUserDefaults().setObject(relativePath, forKey: "path")
        NSUserDefaults.standardUserDefaults().synchronize()
    
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
    
    func getPhoto() {
        
        let possibleOldImagePath = NSUserDefaults.standardUserDefaults().objectForKey("path") as! String?
        if let oldImagePath = possibleOldImagePath {
            
            let oldFullPath = self.documentsPathForFileName(oldImagePath)
            let oldImageData = NSData(contentsOfFile: oldFullPath)
            let oldImage = UIImage(data: oldImageData!)
            
            //println("testy" + oldImageData!.description)
            
            rewardImage.image = oldImage
            
        }
    }
    
    
}
