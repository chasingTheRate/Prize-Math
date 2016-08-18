//
//  ViewController.swift
//  JackieMath2
//
//  Created by Mark Eaton on 4/4/15.
//  Copyright (c) 2015 Eaton Productions. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox

class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate, MainNavigationControllerDelegate {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var equationLabel: UILabel!
    @IBOutlet weak var barbuttonSettings: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var labelView: UIView!
    @IBOutlet var topLevelView: UIView!
    
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    var swipeRight: UISwipeGestureRecognizer!
    var swipeLeft: UISwipeGestureRecognizer!
    
    var calculator = Calculator()
    var colors = Colors()
    //var slideOutTransition = SliderOutTransition()
    
    var index: Int = 0
    var bonusQuestionArray: [[String]] = [[String]]()
    
    var trigger: Int = 0
    var bonusQuestionIsSet: Bool = false
    var timeTicks: Double = 0
    var timeAllowedInSeconds: Double = 0.0
    var colorSelection: Int = 0
    
    //Bonus
    
    var bonus1stNum: Int = 0
    var bonus2ndNum: Int = 0
    var bonusOperator: Calculator.CalcOperator = .Add
    var bonusIsActive: Bool = false

    var numEquations: Int = 0
    var numEquationsSolvedCorrect: Int = 0
    
    var prizeArray = [Prize]()
    
    var timer: NSTimer?
    
    var selectedComplication: Int = 0
    
    //Animation
    
    let labelAnimation = CABasicAnimation(keyPath: "AnimateLabel")
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        //Init Swipe Gestures
        swipeRight = UISwipeGestureRecognizer(target: self, action:"HandleSwipeGestures:")
        swipeRight.direction = .Right
    
        swipeLeft = UISwipeGestureRecognizer(target: self, action: "HandleSwipeGestures:")
        swipeLeft.direction = .Left
    
        //Create Long Press Gesture Recognizer
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress")
        longPressRecognizer.minimumPressDuration = 2.0
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        GetUserSettings()
        UpdateProgressBar()
        UpdateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add Swipe Gestures
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeLeft)
        
        self.NewCalc("")
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func NewCalc(_: AnyObject){
        
        calculator.NewCalc()
        equationLabel.text = calculator.equation
        
        if calculator.stats.totalCount > 0
        {
            calculator.stats.wrong()
        }
        
       //Reset Progress Bar
        progressBar.setProgress(0.0, animated: true)
    }
    
    @IBAction func ChangeAnswer(sender:UIButton!){
        let buttontext = (sender.titleForState(UIControlState.Normal)!)
        calculator.answerText += buttontext
        UpdateEquationLabel()
    }
    
    @IBAction func ClearAnswer(_: AnyObject) {
                calculator.answerText = ""
                UpdateEquationLabel()
    }


    @IBAction func CheckAnswer (_: AnyObject) {
        
        if calculator.answerText != "" {
            calculator.CheckAnswer()
            if calculator.answer{
                CorrectAnswer()
            }else{
                WrongAnswer()
            }
        }else{
            AnimateLabel("wrong")
        }
}
    
    @IBAction func SettingsButtonPressed(sender: AnyObject) {
        
        performSegue()
    }
    
    func UpdateEquationLabel() {
        
        calculator.UpdateEquation()
        self.equationLabel.text = calculator.equation
    }
    

    func HandleSwipeGestures(gesture: UISwipeGestureRecognizer!){
        
        switch gesture.direction{
            
        case UISwipeGestureRecognizerDirection.Right:
            ClearAnswer("")
        case UISwipeGestureRecognizerDirection.Left:
            CheckAnswer("")
        default: break
            }
    }
    
    func UpdateUI() {
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colors.secondaryColor[colorSelection]!]
        
        if userDefaults.boolForKey(UserDefaults.key.nightMode.rawValue){
            topLevelView.backgroundColor = colors.nightModeViewCell
            progressBar.backgroundColor = colors.nightModeViewCell
            progressBar.trackTintColor = colors.nightModeViewCell
        
        }else{
            topLevelView.backgroundColor = colors.nightModeViewCellOff
            progressBar.backgroundColor = colors.nightModeViewCellOff
            progressBar.trackTintColor = colors.nightModeViewCellOff
        }
    }

    func CorrectAnswer() {
        
        if bonusIsActive {
            index++
            correctBonusAnswer(index)
        }else {
            AnimateLabel("right")
        }
        
    }
    
    func WrongAnswer() {
        
        //Vibrate Phone
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        AnimateLabel("wrong")
        
        //reset Bonus Variable
        index = 0
        
        //See completion closure in animation for additional methods
    
        //resetProgressBarAndTimer()
        
    }
    
    func timeExpiredOnBonus(){
        
        //Vibrate Phone
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        AnimateLabel("wrong")
        
        //reset Bonus Variable
        index = 0
        
        //See completion closure in animation for additional methods
        
        resetProgressBarAndTimer()
    }
    
    func correctBonusAnswer(localIndex: Int){
        
        if localIndex > bonusQuestionArray.count-1{
            
            //reset bonus variables
            
            bonusIsActive = false
            index = 0
            
            //Update Equation Label in Main Thread
            dispatch_async(dispatch_get_main_queue()) {
                self.equationLabel.text = "Winner!"
            }
            
            //Turn Off Bonus Switch using User Defaults
            self.userDefaults.setBool(false, forKey: keySetBonusQuestion)
            GetUserSettings()
            
            resetProgressBarAndTimer()
            
            AppendPrizeArray()
            SavePrizes()
            
        }else{
            
            calculator.firstNum = Int(bonusQuestionArray[localIndex][0])!
            calculator.secondNum = Int(bonusQuestionArray[localIndex][2])!
            calculator.operatorText = calculator.CalcStringConversion(bonusQuestionArray[localIndex][1])
            calculator.answerText = ""
            
            AnimateLabel("rightBonus")
        }

    }
    
    func IsBonusQuestionSet() ->Bool{
        
        //Check is Bonus Switch is set to true.
        
        if bonusQuestionIsSet == false {
            return false
        }
        
        if bonusQuestionArray.count == 0{
            return false
        }
        //If all items are set return true
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        _ = segue.destinationViewController as! SettingsViewController2
        //settingsVC.transitioningDelegate = self.slideOutTransition
    }
    
    func performSegue() {
        self.performSegueWithIdentifier("showSettings", sender: nil)
    }
    

    func SavePrizes() {
    
        let prizeData = NSKeyedArchiver.archivedDataWithRootObject(prizeArray)
        userDefaults.setObject(prizeData, forKey: "prizes")
        self.userDefaults.synchronize()
    }
    
    func AppendPrizeArray() {
    
        let keyPrizeTypeData: String = "keyPrizeTypeData"
        let keySelectedPrizeTypeIndex: String = "keySelectedPrizeTypeIndex"
        
        guard let index = Int(userDefaults.stringForKey(keySelectedPrizeTypeIndex)!) else {return}
        
        guard let data = userDefaults.objectForKey(keyPrizeTypeData) as? NSData else {return}
        
        let prizeType = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Prize])!
        
        let newPrize = Prize(title: prizeType[index].title, prizeDescription: prizeType[index].prizeDescription, imagePath: prizeType[index].imagePath)
          
        //Add to Prize Array
        prizeArray.append(newPrize)
    
    }
    
    func AnimateLabel(sender: String){
    
        switch sender{
            
        case "wrong":
            
            let orgCenter: CGPoint = equationLabel.center
            let dur1: NSTimeInterval = 0.10
            let dur2: NSTimeInterval = 0.10
            let dur3: NSTimeInterval = 0.10
            
            UIView.animateWithDuration(dur1, delay: 0.0, options: [], animations: {self.equationLabel.center = CGPointMake(orgCenter.x-30.0, orgCenter.y)}, completion:{finished in UIView.animateWithDuration(dur2, delay: 0.0, options: [], animations: {self.equationLabel.center = CGPointMake(orgCenter.x+30.0, orgCenter.y)}, completion: {finished in UIView.animateWithDuration(dur3, delay: 0.0, options: [], animations: {self.equationLabel.center = CGPointMake(orgCenter.x, orgCenter.y)}, completion: {finished in
                //self.ResetEquationOnWrongBonus()
                self.UpdateEquationLabel()})})})
            
        case "right":
          
            equationLabel.transform = CGAffineTransformScale(equationLabel.transform, 1.0, 1.0)
            equationLabel.textColor = colors.correctColor

            UIView.animateWithDuration(0.30, animations: {
                self.equationLabel.transform = CGAffineTransformScale(self.equationLabel.transform, 1.25, 1.25)}, completion: {finished in UIView.animateWithDuration(0.30, animations: {self.equationLabel.transform = CGAffineTransformScale(self.equationLabel.transform, 0.80, 0.80)}, completion: {finished in self.equationLabel.textColor = self.colors.secondaryColor[self.colorSelection]!
                    self.UpdateProgressBar()
                    self.TriggerBonusQuestion()
                    self.UpdateEquationLabel()})})
            
        case "rightBonus":
            
            equationLabel.transform = CGAffineTransformScale(equationLabel.transform, 1.0, 1.0)
            equationLabel.textColor = colors.correctColor
            
            UIView.animateWithDuration(0.30, animations: {
                self.equationLabel.transform = CGAffineTransformScale(self.equationLabel.transform, 1.25, 1.25)}, completion: {finished in UIView.animateWithDuration(0.30, animations: {self.equationLabel.transform = CGAffineTransformScale(self.equationLabel.transform, 0.80, 0.80)}, completion: {finished in self.equationLabel.textColor = self.colors.secondaryColor[self.colorSelection]
                    self.UpdateEquationLabel()})})
            
        default:
            break
        }
    }
    
    func UpdateProgressBar() {
        
        if trigger != 0 && bonusQuestionIsSet{
            print((Float(calculator.stats.numCorrectInRow)/Float(trigger)))
            progressBar.setProgress((Float(calculator.stats.numCorrectInRow)/Float(trigger)), animated: true)
        }else if bonusQuestionIsSet==false{
            progressBar.setProgress(0.0, animated: true)
        }
    }
    
    func TriggerBonusQuestion() {
        
        // Trigger Bonus Question if...and....

        if trigger <= calculator.stats.numCorrectInRow && IsBonusQuestionSet() {
            calculator.firstNum = Int(bonusQuestionArray[0][0])!
            calculator.secondNum = Int(bonusQuestionArray[0][2])!
            calculator.operatorText = calculator.CalcStringConversion(bonusQuestionArray[0][1])
            calculator.answerText = ""
            bonusIsActive = true
            
            print(calculator.firstNum.description)
            
            //Start Timer
            
            let isTimed = userDefaults.boolForKey(keyTimeSwitch)
            
            if isTimed{
            
                let timeInterval = NSTimeInterval(0.0001)
                timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: Selector("countdown"), userInfo: nil, repeats: true)
            }
            
        }else{
            calculator.NewCalc()
        }
    }

    func countdown(){

        timeTicks = timeTicks + 0.0001
        
        if timeTicks < timeAllowedInSeconds{
            let progress = Float((timeAllowedInSeconds-timeTicks)/(timeAllowedInSeconds))
            progressBar.setProgress(progress, animated: false)
        }else{
            WrongAnswer()
        }
    

    
    }
    
    func ResetEquationOnWrongBonus() {
        if bonusIsActive {
            bonusIsActive = false
            calculator.NewCalc()
            calculator.stats.wrong()
        }
    }
    
    func resetProgressBarAndTimer(){
        
        progressBar.setProgress(0.0, animated: false)
        timeTicks = 0
        timer?.invalidate()
    }
    
    //MARK: User Defaults
    
    let keyEquationArray: String = "keyEquationArray"
    let keySetBonusQuestion: String = "keySetBonusQuestion"
    let keyTriggerText: String = "keyTriggerText"
    let keyTimeTextField: String = "keyTimeTextField" //Bonus Question time allowed
    let keyTimeSwitch: String = "keyTimeSwitch" //Bonus Question Timed? (T/F)
    let keyColorSelection: String = "keyColorSelection"
    
    func GetUserSettings() {
        
        if let value = userDefaults.stringForKey(keyColorSelection){
            colorSelection = Int(value)!
        }
        
        //Is Bonus Question Set
        bonusQuestionIsSet = userDefaults.boolForKey(keySetBonusQuestion)
        
        //Trigger Number
        if let triggerDefault = userDefaults.stringForKey(keyTriggerText){
            trigger = Int(triggerDefault)!
        }
        
        //Prize Array
        if let prizeData = userDefaults.objectForKey("prizes") as? NSData {
            prizeArray = (NSKeyedUnarchiver.unarchiveObjectWithData(prizeData) as? [Prize])!
        }
        
        //Bonus Question Array
        
        if let value = userDefaults.objectForKey(keyEquationArray) as? NSData{
            bonusQuestionArray = (NSKeyedUnarchiver.unarchiveObjectWithData(value) as? [[String]])!
        }
        
        //Time Limit
        
        if let value = userDefaults.stringForKey(keyTimeTextField){
            timeAllowedInSeconds = Double(value)!
        }
        
        //Selected Complication (Bonus)
        
        if let value = userDefaults.objectForKey(UserDefaults.key.selectedComplication.rawValue) as? Int{
            
            selectedComplication = value
        }
    }
}

