//
//  MainTableViewController.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/8/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
// b n.

import UIKit
import AudioToolbox


class MainTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, MainNavigationControllerDelegate, InputViewDelegate, ComplicationsDelegate, UIGestureRecognizerDelegate {

    //MARK: Class Instantiations
    
    var calculator = Calculator()
    var colors = Colors()
    let complications = Complications()
    let type = Type()
    var counting: Counting?
    var bonds: Bonds?
    var selectedTheme = Theme()
    var selectedThemeIndex = 0{
        didSet{
            switch selectedThemeIndex{
            case 0:
                selectedTheme = Ocean()
            case 1:
                selectedTheme = Space()
            default:
                break
            }
            selectedTheme.superview = tableView.backgroundView
        }
    }
    
    //MARK: IBOutlets & Other Controls
    
    weak var progressBar: UIProgressView?
    weak var toolbar: UIToolbar!
    var vibracyView = UIVisualEffectView()
    
    //MARK: Gesture Variables
    
    var swipeRight: UISwipeGestureRecognizer!
    var swipeLeft: UISwipeGestureRecognizer!
    var panGesture: UIPanGestureRecognizer!
    
    var panDistanceDelta: CGFloat = 0.0
    var panTouchOriginX: CGFloat = 0.0
    var currentXLocation: CGFloat!
    var oldXLocation: CGFloat!
    var panDistanceFromOrigin: CGFloat!
    var panLimit: CGFloat!
    var checkColorDelta: CGFloat!
    var clearColorDelta: CGFloat!
    
    //MARK: - Variables

    //MARK: Model Variables
    
    var selectedType = Types.counting
    var selectedTypeChanged = false
    var numberCorrectInRow: Int = 0
    
    //MARK: Counting Variables
    
    var countingMaxValue: Int?{
        get{
            return Int(userDefaults.doubleForKey(UserDefaults.key.maxValue.rawValue))
        }
        set{
            counting?.maxValue = newValue!
        }
    }
    var countingMinValue: Int?{
        get{
            return Int(userDefaults.doubleForKey(UserDefaults.key.minValue.rawValue))
        }
        set{
            counting?.minValue = newValue!
        }
    }
    var countingLockMax: Bool?
    var countingLockMin: Bool?
    var countingView: CountingView?
    
    //MARK: Bond Variables
    
    var bondsView: BondsView?
    
    //MARK: Basic Variables

    var calcObjs: [CalcObj] = []{
        didSet{
            calculator.calcObjs = calcObjs
        }
    }
    
    var randomTermOn = false{
        didSet{
            calculator.randomTermOn = randomTermOn
        }
    }
    
    //MARK: TableView Variables
    
    var buttonLocationsSet = false
    var buttonCenters = [CGPoint]()
    var index: Int = 0
    var bonusQuestionArray: [[String]] = [[String]]()
    var trigger: Int = 0
    var bonusQuestionIsSet: Bool{
        get{
            return userDefaults.boolForKey(UserDefaults.key.setBonusQuestion.rawValue)
        }
    }
    var timeTicks: Double = 0
    var timeAllowedInSeconds: Double = 0.0
    var colorSelection: Int = 0
    var timerOn = false
    
    //MARK: TableView Row Height Variables
    
    var equationRowHeight: CGFloat?
    var keypadRowHeight: CGFloat?
    var statusBarHeight: CGFloat?
    var navBarHeight: CGFloat?
    var tabBarHeight: CGFloat?
    var progressBarHeight: CGFloat?
    var mainScreenHeight: CGFloat?
    
    //MARK: TableView Objects
    
    var inputCellView: UIView?
    var numberPadView: InputView?
    var inputLabel: UILabel?
    var clearImageView: UIImageView?
    var checkImageView: UIImageView?
    var updateImageView: UIImageView!
    
    //MARK: Bonus
    
    var bonusIsActive: Bool = false
    var prizeArray = [Prize]()
    var timer: NSTimer?
    var selectedComplication: Int = 0
    
    //MARK: Animations
    
    let labelAnimation = CABasicAnimation(keyPath: "AnimateLabel")
    var animator: UIDynamicAnimator?
    var gravity: UIGravityBehavior?
    var collision: UICollisionBehavior?
    
    //Mark: Segues
    
    let showSettingsIdentifier = "showSettings"
    
    //MARK: - Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        //Init Swipe Gestures
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(HandleSwipeGestures))
        swipeRight.direction = .Right
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(HandleSwipeGestures))
        swipeLeft.direction = .Left
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(testPan))
        panGesture.delegate = self
    }

    
    //MARK: - View Lifecycle
    
    var initialLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserSettings()
        
        //Add Swipe Gestures
        //view.addGestureRecognizer(swipeRight)
        //view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(panGesture)
        panLimit = panGesture.view!.bounds.width/3.0
    
        let tabController = self.tabBarController as! PrizeMathTabBarController
        
        progressBar = tabController.tabProgressBar
        
        switch selectedType{
        case .counting:
            counting = Counting(max: countingMaxValue!, min: countingMinValue!)
            counting?.newCount()
        case .basic:
            updateCalcModel()
            calculator.newCalc()
            updateInputLabel()
            break
        case .bonds:
            bonds = Bonds(min: countingMinValue!, max: countingMaxValue!)
            bonds?.newBond()
        case .fractions:
            break
        }
        
        updateUI()
        
        //Add Pull-To-Refresh Control
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), forControlEvents: .ValueChanged)
    
        //Add Update Image to Background View
        let length = view.bounds.width/6.0
        let xPos = view.bounds.width/2.0 - length/2.0
        let yPos = navBarHeight! + 20.0
        updateImageView = UIImageView(frame: CGRect(x: xPos, y: yPos, width: length, height: length))
        updateImageView.image = UIImage(named: "updateImage")
        updateImageView.alpha = 0.0
        updateImageView.hidden = true
        
        tableView.backgroundView?.addSubview(updateImageView)
        
        //Start background animation timer
        let _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(animateBackground), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        progressBar!.hidden = false
        
        switch selectedType{
        case .counting:
            if counting == nil{
                counting = Counting(max: countingMaxValue!, min: countingMinValue!)
                counting!.newCount()
            }
        case .basic:
            if selectedTypeChanged == true{
                updateCalcModel()
                calculator.newCalc()
            }
        case .bonds:
            if bonds == nil{
                bonds = Bonds(min: countingMinValue!, max: countingMaxValue!)
                bonds!.newBond()
            }
        case .fractions:
            break
        }
        
        getUserSettings()
        applyImageViewToBackgroundView()
        updateProgressBar()
        updateUI()
        
        if selectedTypeChanged == true{
            resetProgressBarAndTimer()
        }
        
        if initialLoad == false && selectedTypeChanged == true{
            let section = NSIndexSet(indexesInRange: NSMakeRange(0,2))
            tableView.reloadSections(section, withRowAnimation: .Automatic)
        }else{
            initialLoad = false
        }
        
        updateInputLabel()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)
        
        saveUserDefaults()
    }

    //MARK: - UI Updates
    
    func updateUI(){
        
        //Update Naviation Bar - Clear Bar
        let navBar = (navigationController?.navigationBar)!
        navBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = UIImage()
        navBar.backgroundColor = UIColor.clearColor()
        navBar.tintColor = UIColor.whiteColor()
        
        navBarHeight = navigationController?.navigationBar.bounds.height
        tabBarHeight =  tabBarController?.tabBar.bounds.height
        statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        mainScreenHeight = UIScreen.mainScreen().bounds.height
        
        let typeRatio: CGFloat = typeToCellHeightRatio(selectedType)
        let keyPadRatio: CGFloat = 1 - typeRatio
        
        equationRowHeight =  typeRatio*(mainScreenHeight! - (navBarHeight! + tabBarHeight! + statusBarHeight!))
        
        keypadRowHeight = keyPadRatio*(mainScreenHeight! - (navBarHeight! + tabBarHeight! + statusBarHeight!))
        
       
        tableView.backgroundColor = colors.secondaryColor[0]
    }
    
    func ResetEquationOnWrongBonus() {
        if bonusIsActive {
            bonusIsActive = false
            calculator.newCalc()
            calculator.stats.wrong()
        }
    }
    
    func resetProgressBarAndTimer(){
        
        numberCorrectInRow = 0
        progressBar!.setProgress(0.0, animated: false)
        timeTicks = 0
        timer?.invalidate()
    }
    
    func updateProgressBar() {
        
        //print("trigger: \(trigger), Bonus Set: \(bonusQuestionIsSet), # Correct in Row: \(numberCorrectInRow)")
        if trigger != 0 && bonusQuestionIsSet{
            progressBar!.setProgress((Float(numberCorrectInRow)/Float(trigger)), animated: true)
        }else if bonusQuestionIsSet==false{
            progressBar!.setProgress(0.0, animated: true)
        }
    }
    
    func pullToRefresh(){
        if refreshControl!.refreshing{
            dispatch_async(dispatch_get_main_queue(),{
                self.updateImageView.transform = CGAffineTransformScale(self.updateImageView.transform, 1.0, 1.0)
                UIView.animateWithDuration(0.30, animations: {
                    self.updateImageView.transform = CGAffineTransformScale(self.updateImageView.transform, 1.5, 1.5)}, completion: {finished in UIView.animateWithDuration(0.30, animations: {self.updateImageView.transform = CGAffineTransformScale(self.updateImageView.transform, 0.8, 0.8)}, completion: nil)})
                self.resetCalc()
            })
        }
        self.refreshControl?.endRefreshing()
    }
    
    //MARK: Segue Methods
    
    func performSegue() {
        self.performSegueWithIdentifier("showSettings", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            switch identifier{
            case showSettingsIdentifier:
                let vc = segue.destinationViewController as? SettingsViewController2
                vc?.calculator = calculator
            default:
                break
            }
        }
    }
    
    //MARK: Timer Methods
    
    func timeExpiredOnBonus(){
        
        //Vibrate Phone
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        AnimateLabel("wrong")
        
        //reset Bonus Variable
        index = 0
        
        //See completion closure in animation for additional methods
        
        resetProgressBarAndTimer()
    }
    
    func countdown(){
        
        timeTicks = timeTicks + 0.0001
        
        if timeTicks < timeAllowedInSeconds{
            let progress = Float((timeAllowedInSeconds-timeTicks)/(timeAllowedInSeconds))
            progressBar!.setProgress(progress, animated: false)
        }else{
            wrongAnswer()
        }
    }
    
    //MARK: - TableView
    
    // MARK: TableView Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        switch indexPath.section{
            
        case 0:
            
            switch selectedType{
                
            case .counting:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("countingTableViewCell", forIndexPath: indexPath) as! CountingTableViewCell
                
                cell.contentView.layoutSubviews()
            
                inputLabel = cell.inputLabel
                inputLabel!.text = ""
            
                countingView = cell.countingView
                countingView?.countItems = counting?.count
                countingView?.primaryColor = colors.primaryColor[0]!
                countingView?.secondaryColor = colors.secondaryColor[0]!
                
                countingView?.createCountingItems()

                return cell
                
            case .bonds:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("bondsTableViewCell", forIndexPath: indexPath) as! BondsTableViewCell

                bondsView = cell.bondsView
                
                switch bonds!.activeBubble!{
                case 0:
                    inputLabel = bondsView!.wholeBubble
                    cell.bondsView.wholeValue = ""
                    cell.bondsView.firstValue = String(bonds!.firstPartBubble!)
                    cell.bondsView.secondValue = String(bonds!.secondPartBubble!)
                case 1:
                    inputLabel = bondsView!.firstPartBubble
                    cell.bondsView.wholeValue = String(bonds!.wholeBubble!)
                    cell.bondsView.firstValue = ""
                    cell.bondsView.secondValue = String(bonds!.secondPartBubble!)
                case 2:
                    inputLabel = bondsView!.secondPartBubble
                    cell.bondsView.wholeValue = String(bonds!.wholeBubble!)
                    cell.bondsView.firstValue = String(bonds!.firstPartBubble!)
                    cell.bondsView.secondValue = ""
                default:
                    break
                }
                
                cell.bondsView.updateLabels()
                
                return cell
                
            default:
            
                let cell = tableView.dequeueReusableCellWithIdentifier("equationSimpleMathHorizontal", forIndexPath: indexPath) as! SimpleMathHorizontalTableViewCell
                inputLabel = cell.equationLabel
                inputLabel!.text = calculator.equationAsString
                clearImageView = cell.clearImageView
                checkImageView = cell.checkImageView
                
                return cell
            }
     
        case 1:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("keypad", forIndexPath: indexPath) as! DefaultKeyPadTableViewCell

            cell.numberPadView.blurEffectStyle = selectedTheme.inputBlurEffectStyle
            cell.numberPadView.buttonBorderColor = selectedTheme.inputBorderColor
            //cell.numberPadView.vibrancyEffectView.frame = cell.numberPadView.frame
            
            numberPadView = cell.numberPadView
            numberPadView!.delegate = self
            numberPadView!.alpha = 1.0
            
            cell.contentView.layoutIfNeeded()
            cell.numberPadView.updateConstraints()

            return cell
        
        default:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("equationSimpleMathHorizontal", forIndexPath: indexPath)
            
            return cell
        }

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return equationRowHeight!
        case 1:
            return keypadRowHeight!
        default:
            return 44.0
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
    
            if scrollView.dragging && scrollView.contentOffset.y < -64{
                updateImageView.alpha = abs(scrollView.contentOffset.y/300)
            }
            updateImageView.transform = CGAffineTransformMakeRotation(abs(scrollView.contentOffset.y/25))
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        UIView.animateWithDuration(0.25, animations: {
            self.updateImageView.alpha = 0.0
            }, completion: {finished in self.updateImageView.hidden=true})
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        updateImageView.hidden = false
    }
    
    func typeToCellHeightRatio(sender: Types) -> CGFloat{
        switch sender{
        case .counting:
            return 0.4
        case .basic:
            return 0.2
        case .bonds:
            return 0.4
        case .fractions:
            return 0.4
        }
    }
    

    //MARK: - Gesture Recognizer Methods
    
    func HandleSwipeGestures(gesture: UISwipeGestureRecognizer!){
        
        switch gesture.direction{
            
        case UISwipeGestureRecognizerDirection.Right:
            clearAnswer()
        case UISwipeGestureRecognizerDirection.Left:
            checkAnswer()
        default: break
        }
    }
    
    func testPan(gesture: UIPanGestureRecognizer){
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (self.inputLabel?.text)!)
        
        switch gesture.state{
        case .Began:
            panTouchOriginX = gesture.locationInView(gesture.view).x
            currentXLocation = panTouchOriginX
            panDistanceDelta = 0.0
            panDistanceFromOrigin = 0.0
            checkColorDelta = 0.0
            clearColorDelta = 0.0
            
            checkImageView?.alpha = 0.0
            checkImageView?.hidden = false
            clearImageView?.alpha = 0.0
            clearImageView?.hidden = false
            
        case .Changed:
            oldXLocation = currentXLocation
            currentXLocation = gesture.locationInView(gesture.view).x
            
            panDistanceDelta = currentXLocation - oldXLocation
            panDistanceFromOrigin = currentXLocation - panTouchOriginX
            
            //print(panDistanceFromOrigin)
            //print("Pan Delta: \(panDistanceDelta)")
        
            if panDistanceDelta >= 0{
                //Panning Right
        
                inputLabel?.center.x += 0.1
                checkImageView?.alpha += 0.025
                clearImageView?.alpha -= 0.025
                checkColorDelta = checkColorDelta + 0.01
                clearColorDelta = clearColorDelta - 0.01
                
                let range = NSMakeRange(calculator.userInputStartingLocation, calculator.userInputLength)
            
                let color = UIColor.whiteColor().colorWithAlphaComponent(1 - clearColorDelta)
                
                attributeString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
                self.inputLabel?.attributedText = attributeString
                
            }else{
                
                //Panning Left

                clearImageView?.alpha += 0.025
                checkImageView?.alpha -= 0.025
                checkColorDelta = checkColorDelta - 0.025
                clearColorDelta = clearColorDelta + 0.025
                
                let color = UIColor.whiteColor().colorWithAlphaComponent(1 - clearColorDelta)
            
                attributeString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(calculator.userInputStartingLocation, calculator.userInputLength))
                
                self.inputLabel?.attributedText = attributeString
                
                
            }
        
        case .Cancelled:
            gesture.enabled = true
            hideCheckClearImages()
        case .Ended:
            
            if panDistanceFromOrigin > panLimit{
                self.checkAnswer()
                //gesture.enabled = false
            }else if panDistanceFromOrigin < -panLimit{
                self.clearAnswer()
                //gesture.enabled = false
            }else{
                //inputLabel?.textColor = UIColor.whiteColor()
                updateInputLabel()
            }
        
            hideCheckClearImages()
            
        default:
            break
        }
    }
    
    func hideCheckClearImages(){
        UIView.animateWithDuration(0.25, animations: {
            self.checkImageView?.alpha = 0.0
            self.clearImageView?.alpha = 0.0
            }) { finished in
                self.checkImageView?.hidden = true
                self.clearImageView?.hidden = true
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let pan = gestureRecognizer as! UIPanGestureRecognizer
        
        //Ignore Vertical Pans
        if abs(pan.velocityInView(pan.view).x) > abs(pan.velocityInView(pan.view).y){
            return true
        }else{
            return false
        }
    }
    
    //MARK: - Theme Methods
    
    func animateBackground(){
        selectedTheme.animateBackgroundView()
    }
    
    func applyImageViewToBackgroundView(){
        
        //Set Background Image w/ blur effect
        tableView.backgroundView = UIImageView(image: UIImage(named: selectedTheme.backgroundImageName!))
        selectedTheme.superview = tableView.backgroundView!
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: selectedTheme.backgroundImageBlurEffect))
        blurView.frame = (tableView.backgroundView?.bounds)!
        tableView.backgroundView!.addSubview(blurView)
    }
    
    //MARK: - Model(Basic, Counting, Bonds...) Methods
    
    func newCalc(){
        
        inputLabel?.adjustsFontSizeToFitWidth = true
        
        switch selectedType{
        case .counting:
            counting?.newCount()
            countingView?.countItems = counting!.count
        case .basic:
            calculator.newCalc()
            inputLabel!.text = calculator.equationAsString
            updateInputLabel()
        case .bonds:
            bonds!.answer = ""
            updateInputLabel()
            bonds?.newBond()
        case .fractions:
            break
        }
    }
    
    func resetCalc() {
        
        switch selectedType{
        case .counting:
            counting?.newCount()
            counting?.stats.wrong()
            countingView?.countItems = counting!.count
            countingView?.createCountingItems()
        case .basic:
            calculator.newCalc()
            calculator.stats.wrong()
            inputLabel!.text = calculator.equationAsString
            updateInputLabel()
        case .bonds:
            bonds!.answer = ""
            updateInputLabel()
            bonds?.newBond()
            bonds?.stats.wrong()
        case .fractions:
            break
        }
        
        //Reset Bonus
        
        if bonusIsActive{
            bonusIsActive = false
        }
        
        //Reset Progress Bar
        progressBar!.setProgress(0.0, animated: true)
        

        //Remove any active animators
        
        if complications.active{
            
            //Reset Complication Variable
            complications.active = false
            
            for i in 1...numberPadView!.subviews.count{
                
                let subview = numberPadView!.subviews[i-1]
                
                let maxTimeInMilliseconds: UInt32 = 100
                let randomDuration: NSTimeInterval
                
                if i == numberPadView!.subviews.count{
                    randomDuration = NSTimeInterval(maxTimeInMilliseconds/100)
                }else{
                    randomDuration = NSTimeInterval((Double(arc4random_uniform(maxTimeInMilliseconds)))/100)
                    
                }
                UIView.animateWithDuration(randomDuration, animations: {
                    subview.alpha = 0.0
                    }, completion: {finished in
                        
                        if i == self.numberPadView!.subviews.count{
                            
                            self.complications.cleanUp(self.numberPadView!)
                            
                            //Reload Load Table
                            self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
                        }})
                
            }
        }
    }
   
    
    func updateInputLabel() {
        
        switch selectedType{
        case .counting:
            inputLabel?.text = counting!.answer
        case .basic:
            if calculator.userInput == "" {
                //Underline blank text (No input from user)
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: calculator.equationAsString)
                let range = NSMakeRange(calculator.userInputStartingLocation, 4)
                attributeString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: range)
                self.inputLabel?.attributedText = attributeString
            }else{
                self.inputLabel!.text = calculator.equationAsString
            }
        case .bonds:
            inputLabel?.text = bonds?.answer
        case .fractions:
            break
        }
    }
    
    func changeAnswer(sender: String){
        
        switch selectedType{
        case .counting:
            counting!.answer += sender
        case .basic:
            calculator.userInput += sender
        case .bonds:
            bonds?.answer += sender
        case .fractions:
            break
        }
        
        updateInputLabel()

    }
    
    func checkAnswer() {
        
        switch selectedType{
        case .counting:
            if counting!.answer != ""{
                if counting!.checkAnswer(){
                    numberCorrectInRow = counting!.stats.numCorrectInRow
                    correctAnswer()
                }else{
                    counting?.answer = ""
                    wrongAnswer()
                }
            }
        case .basic:
            if calculator.userInput != "" {
                if calculator.checkAnswer(){
                    numberCorrectInRow = calculator.stats.numCorrectInRow
                    correctAnswer()
                }else{
                    wrongAnswer()
                }
            }else{
                AnimateLabel("wrong")
            }
        case .bonds:
            if bonds!.answer != "" {
                if bonds!.checkAnswer(){
                    numberCorrectInRow = bonds!.stats.numCorrectInRow
                    correctAnswer()
                }else{
                    bonds?.answer = ""
                    wrongAnswer()
                }
            }
        case .fractions:
            break
            
        }
    }
    
    func clearAnswer() {
        
        switch selectedType{
        case .counting:
            counting?.answer = ""
        case .basic:
            calculator.userInput = ""
        case .bonds:
            bonds?.answer = ""
        case .fractions:
            break
        }
        
        self.inputLabel!.textColor = UIColor.whiteColor()
        updateInputLabel()
    }
    
    func correctAnswer() {
        
        if bonusIsActive {
            index += 1
            correctBonusAnswer(index)
        }else {
            AnimateLabel("right")
        }
    }
    
    func wrongAnswer() {
        
        //Vibrate Phone
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        AnimateLabel("wrong")
        
        //reset Bonus Variable
        index = 0
        
        //See completion closure in animation for additional methods
        
        //resetProgressBarAndTimer()
        
    }
    
    func updateModelOnWrongAnswer(){
        
        switch selectedType{
        case .basic:
            calculator.userInput = ""
        default:
            break
        }
    }
    
    func correctBonusAnswer(localIndex: Int){
        
        if localIndex > bonusQuestionArray.count-1{
            
            //reset bonus variables
            
            bonusIsActive = false
            index = 0
            
            //Update Equation Label in Main Thread
            dispatch_async(dispatch_get_main_queue()) {
                self.inputLabel!.text = "Winner!"
            }
            
            //Turn Off Bonus Switch using User Defaults
            userDefaults.setBool(false, forKey: UserDefaults.key.setBonusQuestion.rawValue)
        
            resetProgressBarAndTimer()
            
            AppendPrizeArray()
            
        }else{
            
            calculator.firstNum = Int(bonusQuestionArray[localIndex][0])!
            calculator.secondNum = Int(bonusQuestionArray[localIndex][2])!
            calculator.operatorText = calculator.CalcStringConversion(bonusQuestionArray[localIndex][1])
            calculator.answerText = ""
            
            AnimateLabel("rightBonus")
        }
        
    }
    
    func AnimateLabel(sender: String){
        
        switch sender{
            
        case "wrong":
            
            let orgCenter: CGPoint = inputLabel!.center
            let dur1: NSTimeInterval = 0.10
            let dur2: NSTimeInterval = 0.10
            let dur3: NSTimeInterval = 0.10
            
            UIView.animateWithDuration(dur1, delay: 0.0, options: [], animations: {self.inputLabel!.center = CGPointMake(orgCenter.x-30.0, orgCenter.y)}, completion:{finished in UIView.animateWithDuration(dur2, delay: 0.0, options: [], animations: {self.inputLabel!.center = CGPointMake(orgCenter.x+30.0, orgCenter.y)}, completion: {finished in UIView.animateWithDuration(dur3, delay: 0.0, options: [], animations: {self.inputLabel!.center = CGPointMake(orgCenter.x, orgCenter.y)}, completion: {finished in
                //self.ResetEquationOnWrongBonus()
                self.inputLabel!.textColor = UIColor.whiteColor()
                self.updateModelOnWrongAnswer()
                self.updateInputLabel()})})})
            
        case "right":
            
            inputLabel!.transform = CGAffineTransformScale(inputLabel!.transform, 1.0, 1.0)
            inputLabel!.textColor = colors.correctColor
            
            UIView.animateWithDuration(0.30, animations: {
                self.inputLabel!.transform = CGAffineTransformScale(self.inputLabel!.transform, 1.25, 1.25)}, completion: {finished in UIView.animateWithDuration(0.30, animations: {self.inputLabel!.transform = CGAffineTransformScale(self.inputLabel!.transform, 0.80, 0.80)}, completion: {finished in self.inputLabel!.textColor = UIColor.whiteColor()
                    self.updateProgressBar()
                    self.TriggerBonusQuestion()
                    self.updateInputLabel()})})
            
        case "rightBonus":
            
            inputLabel!.transform = CGAffineTransformScale(inputLabel!.transform, 1.0, 1.0)
            inputLabel!.textColor = colors.correctColor
            
            UIView.animateWithDuration(0.30, animations: {
                self.inputLabel!.transform = CGAffineTransformScale(self.inputLabel!.transform, 1.25, 1.25)}, completion: {finished in UIView.animateWithDuration(0.30, animations: {self.inputLabel!.transform = CGAffineTransformScale(self.inputLabel!.transform, 0.80, 0.80)}, completion: {finished in self.inputLabel!.textColor = self.colors.secondaryColor[self.colorSelection]
                    self.updateInputLabel()})})
            
        default:
            break
        }
    }
    
    //MARK: - Settings View Delegate Methods
    
    func updateCalcModel() {
        
        calculator.operatorArray.removeAll()
        
        //Update Operator Array
        if userDefaults.boolForKey(UserDefaults.key.switchAddition.rawValue){
            calculator.operatorArray.append(.Add)
        }
        if userDefaults.boolForKey(UserDefaults.key.switchSubtraction.rawValue){
            calculator.operatorArray.append(.Subtract)
        }
        if userDefaults.boolForKey(UserDefaults.key.switchMultiplication.rawValue){
            calculator.operatorArray.append(.Multiply)
        }
        if userDefaults.boolForKey(UserDefaults.key.switchDivider.rawValue){
            calculator.operatorArray.append(.Divide)
        }
    }
    
    //MARK: - Bonus Question Methods
    
    func TriggerBonusQuestion() {
        
        // Trigger Bonus Question if...and....
        
        if trigger <= calculator.stats.numCorrectInRow && IsBonusQuestionSet() {
            calculator.firstNum = Int(bonusQuestionArray[0][0])!
            calculator.secondNum = Int(bonusQuestionArray[0][2])!
            calculator.operatorText = calculator.CalcStringConversion(bonusQuestionArray[0][1])
            calculator.answerText = ""
            bonusIsActive = true
            calculator.updateEquation()
            print(calculator.equationAsString)
            
            updateInputLabel()
            
            //Start Timer

            if timerOn{
                
                let timeInterval = NSTimeInterval(0.0001)
                timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
            }
            
            //Apply Complication
            
            complications.delegate = self
            complications.active = true
            
            switch selectedComplication{
                
            case 1:
                complications.gravity(numberPadView!)
            case 2:
                complications.decoy(numberPadView!)
            case 3:
                complications.orbit(numberPadView!)
            case 4:
                complications.ghost(numberPadView!)
            default:
                break
            }
        
        }else{
            newCalc()
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
    
    
    //MARK: - Prize Methods
    
    func AppendPrizeArray() {
        
        let keyPrizeTypeData: String = "keyPrizeTypeData"
        let keySelectedPrizeTypeIndex: String = "keySelectedPrizeTypeIndex"
        
        guard let index = Int(userDefaults.stringForKey(keySelectedPrizeTypeIndex)!) else {return}
        
        guard let data = userDefaults.objectForKey(keyPrizeTypeData) as? NSData else {return}
        
        let prizeType = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Prize])!
        
        let newPrize = Prize(title: prizeType[index].title, prizeDescription: prizeType[index].prizeDescription, imagePath: prizeType[index].imagePath)
        
        //Add to Prize Array
        prizeArray.append(newPrize)
        print(prizeArray.count)
        
    }
    
    //MARK: - User Defaults Methods
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func getUserSettings() {
        
        //Selected Theme Index
        selectedThemeIndex = userDefaults.integerForKey(UserDefaults.key.selectedTheme.rawValue)
        
        if let value = userDefaults.stringForKey(UserDefaults.key.colorSelection.rawValue){
            colorSelection = Int(value)!
        }
        
        //Trigger Number
        if let triggerDefault = userDefaults.stringForKey(UserDefaults.key.triggerText.rawValue){
            trigger = Int(triggerDefault)!
        }
        
        //Prize Array
        if let prizeData = userDefaults.objectForKey(UserDefaults.key.prizesWon.rawValue) as? NSData {
            prizeArray = (NSKeyedUnarchiver.unarchiveObjectWithData(prizeData) as? [Prize])!
        }
        
        //Bonus Question Array
        
        if let value = userDefaults.objectForKey(UserDefaults.key.bonusQuestions.rawValue) as? NSData{
            bonusQuestionArray = (NSKeyedUnarchiver.unarchiveObjectWithData(value) as? [[String]])!
        }
        
        print(bonusQuestionArray.count)
        
        //Time Limit
        
        if let value = userDefaults.stringForKey(UserDefaults.key.timeText.rawValue){
            timeAllowedInSeconds = Double(value)!
        }
        
        //Timer On?
        
        timerOn = userDefaults.boolForKey(UserDefaults.key.timeSwitch.rawValue)
        
        //Selected Complication (Bonus)
        
        if let value = userDefaults.objectForKey(UserDefaults.key.selectedComplication.rawValue) as? Int{
            
            selectedComplication = value
        }
        
        //Selected Type
        
        let int = userDefaults.integerForKey(UserDefaults.key.selectedTypeSettings.rawValue)
        selectedType = Types.convertIntToType(int)! //type.convertIntToType(int)!
        
        //Min & Max Numbers
        
        countingMaxValue = Int(userDefaults.doubleForKey(UserDefaults.key.maxValue.rawValue))
        countingMinValue = Int(userDefaults.doubleForKey(UserDefaults.key.minValue.rawValue))
        
        //Calc Objects
        let basicData = userDefaults.objectForKey(UserDefaults.key.calcObj.rawValue) as? NSData
        if basicData != nil {
            calcObjs = (NSKeyedUnarchiver.unarchiveObjectWithData(basicData!) as? [CalcObj])!
        }
        if calcObjs.count == 0{
            let defaultCalc = CalcObj(id: 0, min: 0, max: 9, locked: false, op: "+")
            calcObjs.append(defaultCalc)
        }
        print(calcObjs.count)
        
        randomTermOn = userDefaults.boolForKey(UserDefaults.key.randomTerm.rawValue)
    }
    
    func saveUserDefaults(){
        
        //Update Bonus Question Status
        self.userDefaults.setBool(bonusQuestionIsSet, forKey: UserDefaults.key.setBonusQuestion.rawValue)
        
        let prizeData = NSKeyedArchiver.archivedDataWithRootObject(prizeArray)
        userDefaults.setObject(prizeData, forKey: UserDefaults.key.prizesWon.rawValue)
    }

}
