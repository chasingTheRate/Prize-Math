//
//  SetBonuesQuestionTableViewController.swift
//  Prize Math
//
//  Created by Mark Eaton on 12/29/15.
//  Copyright © 2015 Eaton Productions. All rights reserved.
//

import UIKit

class SetBonuesQuestionTableViewController: UITableViewController {
    
    let colors = Colors()
    let complications = Complications()
    let mathEquations = MathEquations()
    
    var timedCellRowHeight: CGFloat = 44.0
    var segmentControlCellRowHeight: CGFloat = 60.0
    var numQuestionsCellRowHeight: CGFloat = 0.0
    var randomCellRowHeight: CGFloat = 75.0
    var equationCellRowHeight: CGFloat = 75.0
    var collectionViewRowHeight: CGFloat = 117.0
    var numOfQuestions: Int = 0
    var selectedType: Int = 0
    var selectedComplication: Int = 0
    
    var bonusOn: Bool = false{
        didSet{
            if bonusOn{
                bonusLabelText = "ON"
            }else{
                bonusLabelText = "OFF"
            }
            userDefaults.setBool(bonusOn, forKey: UserDefaults.key.setBonusQuestion.rawValue)
        }
    }
    
    var bonusStatusLabel: UILabel?
    var bonusLabelText: String?
    
    var isTimed: Bool = false{
        didSet{
            if isTimed{
                timedCellRowHeight = 88.0
            }else{
                timedCellRowHeight = 44.0
            }
        }
    }
    
    var timeText: String?
    var trigger: String?{
        didSet{
            self.userDefaults.setObject(trigger, forKey: UserDefaults.key.triggerText.rawValue)
        }
    }
    
    var maxNumber1st: UInt32 = 0
    var maxNumber2nd: UInt32 = 0
    var lockFirstNumber: Bool = false
    var lockSecondNumber: Bool = false
    
     let sectionHeaderHeight: CGFloat = 40.0

    var operatorArray: [String] = []
    var equationArray: [[String]] = [[String]]()
    
    @IBOutlet var tableViewSetBonus: UITableView!
    
    var nightMode: Bool = false
    
    //Section Designation
    
    let bonusOnSection: Int = 0
    let bonusQuestionTypeSection: Int  = 1
    let bonusQuestionComplicationSection: Int  = 2
    let bonusOptionsSection: Int  = 3
    let bonusRandomQuestionsSection: Int  = 4

    //Gestures
    
    var tap: UITapGestureRecognizer?
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        getUserSettings()
        updateUI()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)
    
        DismissKeyboard()
        saveUserSettings()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section{
        
        case 0:
            return 1
        case 3:
            return 3
        case 4:
            return numOfQuestions + 1
        default:
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section
        {
        
        case bonusOnSection:
            let cell = tableView.dequeueReusableCellWithIdentifier("turnOnBonusCell", forIndexPath: indexPath) as! SetBonusQuestionTableViewCell
            
            bonusStatusLabel = cell.labelSetBonusQuestion
            
            cell.switchSetBonusQuestion.on = bonusOn
            cell.labelSetBonusQuestion.text = bonusLabelText!
            cell.switchSetBonusQuestion.addTarget(self, action: #selector(switchChangedValue), forControlEvents: .ValueChanged)
        
            nightMode(cell.contentView)
            
            return cell
            
        case bonusQuestionTypeSection:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("collectionViewInTableViewCell", forIndexPath: indexPath) as! CollectionViewInTableViewCell
            
            cell.tag = 0
            
            return cell
            
        case bonusQuestionComplicationSection:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("collectionViewInTableViewCell", forIndexPath: indexPath) as! CollectionViewInTableViewCell
            
            cell.tag = 1

            return cell
            
        case bonusOptionsSection:
            
            switch indexPath.row
            {

            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("timedCell", forIndexPath: indexPath) as! TimedTableViewCell
                
                cell.switchTimed.on = isTimed
                
                cell.switchTimed.addTarget(self, action: #selector(switchChangedValue), forControlEvents: .ValueChanged)
                
                cell.textFieldTimed.text = timeText
                cell.textFieldTimed.addTarget(self, action: #selector(addTapGesture), forControlEvents: .EditingDidBegin)
                cell.textFieldTimed.addTarget(self, action: #selector(textFieldValueChanged), forControlEvents: .EditingDidEnd)
               
                nightMode(cell.contentView)
                
            return cell
                
            case 1:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("triggerCell", forIndexPath: indexPath) as! TriggerTableViewCell
                
                    cell.textFieldTrigger.text = trigger
                cell.textFieldTrigger.addTarget(self, action: #selector(addTapGesture), forControlEvents: .EditingDidBegin)
                cell.textFieldTrigger.addTarget(self, action: #selector(textFieldValueChanged), forControlEvents: .EditingDidEnd)
                
                    nightMode(cell.contentView)
                
                return cell
 
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier("numOfEquationsCell", forIndexPath: indexPath) as! NumOfEquationsTableViewCell
                
                cell.textFieldNumOfEquation.text = numOfQuestions.description
                cell.textFieldNumOfEquation.addTarget(self, action: #selector(addTapGesture), forControlEvents: .EditingDidBegin)
                cell.textFieldNumOfEquation.addTarget(self, action: #selector(textFieldValueChanged), forControlEvents: .EditingDidEnd)
            
                    nightMode(cell.contentView)
                
                return cell
                
            default:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("numOfEquationsCell", forIndexPath: indexPath) as! NumOfEquationsTableViewCell
                
                    nightMode(cell.contentView)
                
                return cell
                
            }

        case bonusRandomQuestionsSection:
            
            switch indexPath.row
            {
            case 0:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("randomCell", forIndexPath: indexPath) as! RandomTableViewCell
                cell.buttonRandomGenerator.addTarget(self, action: #selector(createRandomEquations), forControlEvents: .TouchUpInside)
                
                nightMode(cell.contentView)
                
                return cell
                
             default:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("equationCell", forIndexPath: indexPath) as! BonusQuestionEquationTableViewCell
            
                cell.textFieldOperator.addTarget(self, action: #selector(ShowOperatorActionSheet), forControlEvents: .EditingDidBegin)
                cell.textFieldOperator.addTarget(self, action: #selector(textFieldValueChanged), forControlEvents: .EditingDidEnd)
                
                cell.textField1stNumber.addTarget(self, action: #selector(addTapGesture), forControlEvents: .EditingDidBegin)
                cell.textField1stNumber.addTarget(self, action: #selector(textFieldValueChanged), forControlEvents: .EditingDidEnd)
                
                cell.textField2ndNumber.addTarget(self, action: #selector(addTapGesture), forControlEvents: .EditingDidBegin)
                cell.textField2ndNumber.addTarget(self, action: #selector(textFieldValueChanged), forControlEvents: .EditingDidEnd)
               
                if equationArray.count != 0 {
                    
                    cell.textField1stNumber.text = equationArray[indexPath.row-1][0]
                    cell.textFieldOperator.text = equationArray[indexPath.row-1][1]
                    cell.textField2ndNumber.text = equationArray[indexPath.row-1][2]
                    
                }else{
                    
                    appendEquationArray(numOfQuestions)
                    
                    cell.textField1stNumber.text = equationArray[indexPath.row-1][0]
                    cell.textFieldOperator.text = equationArray[indexPath.row-1][1]
                    cell.textField2ndNumber.text = equationArray[indexPath.row-1][2]
                }
                
                nightMode(cell.contentView)
                
                return cell
        
            }

        default:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("equationCell", forIndexPath: indexPath) as! BonusQuestionEquationTableViewCell
            
                nightMode(cell.contentView)
            
            return cell
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelect detected!")
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.section
        {
        case bonusOptionsSection:
            switch indexPath.row{
            case 0:
                return timedCellRowHeight
            default:
                return 44
            }
        case bonusRandomQuestionsSection:
            switch indexPath.row
            {
            case 0:
                return randomCellRowHeight
            default:
                return equationCellRowHeight
            }
        case bonusQuestionTypeSection:
            return collectionViewRowHeight
        case bonusQuestionComplicationSection:
            return collectionViewRowHeight
        default:
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! HeaderCell
    
        cell.backgroundColor = UIColor.clearColor()
        
        if nightMode{
            cell.headerView.backgroundColor = colors.nightModeSection
            cell.headerLabel.textColor =  colors.nightModeSectionText
        }else{
            cell.headerView.backgroundColor = colors.nightModeSectionOff
            cell.headerLabel.textColor =  colors.nightModeSectionTextOff
        }
        
        switch section{
            
        case bonusOnSection:
            cell.headerLabel.text = "STATUS"
        case bonusOptionsSection:
            cell.headerLabel.text = "SELECT OPTIONS"
        case bonusRandomQuestionsSection:
            cell.headerLabel.text = "EDIT QUESTIONS"
        case bonusQuestionTypeSection:
            cell.headerLabel.text = "SELECT TYPE"
        case bonusQuestionComplicationSection:
            cell.headerLabel.text = "SELECT COMPLICATION"
        default:
            cell.headerLabel.text = "ERROR!"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section{
        case 0:
            return 60
        default:
            return sectionHeaderHeight
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("footerCell") as! FooterCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        if nightMode{
            cell.contentView.backgroundColor = colors.nightModeSection
        }else{
            cell.contentView.backgroundColor = colors.nightModeSectionOff
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        switch section{
        case 4:
            return 1.0
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? CollectionViewInTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
    }
    
    func updateUI(){
 
        if nightMode{
            tableView.backgroundColor = colors.nightModeSection
        }else{
            tableView.backgroundColor = colors.nightModeSectionOff
        }
    }
    
    
    func nightMode(sender: UIView){
        
        if nightMode{
            sender.superview!.backgroundColor = colors.nightModeViewCell
            sender.layer.borderColor = colors.nightModeViewCell.CGColor
        }else{
            sender.superview!.backgroundColor = colors.nightModeViewCellOff
            sender.layer.borderColor = colors.nightModeViewCellOff.CGColor
        }
    }

    //MARK: Switch Changes
    
    func switchChangedValue(sender: UISwitch){
        
        switch sender.tag{

        case 0: //Bonus Status Switch
            
            bonusOn = sender.on
            
            //Update Bonus Status Label in Main Thread
            dispatch_async(dispatch_get_main_queue()) {
                self.bonusStatusLabel!.text = self.bonusLabelText
            }
            
        case 1: //Is Timed Switch
                
            isTimed = sender.on
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
                
        default:
            break
                
        }
    }
    
    //MARK: Text Field Changes
    
    func textFieldValueChanged(sender: UITextField) {
        switch sender.tag{
        case 1://1st Number
            self.updateEquationArray(sender, column: 0)
        case 2: //2nd Number
            self.updateEquationArray(sender, column: 2)
        case 4: //Time in Seconds
            timeText = sender.text
        case 5: //Trigger
            trigger = sender.text
        case 6: //# of Questions
            numOfQuestions = Int(sender.text!)!
            updateNumberOfEquations(sender)
        default:
            break
        }
    }

    //MARK: Bonus Equation Functions (MODEL)
    
    func updateNumberOfEquations(sender: UITextField){
        
        let difference = abs(equationArray.count - numOfQuestions)
        var indexPaths = [NSIndexPath]()
        var row: Int = 0
        
        if equationArray.count > numOfQuestions{
            
            //Create Index Path Array
            
            for i in 1...difference{
                row = equationArray.count - i + 1
                indexPaths.append(NSIndexPath(forRow: row, inSection: bonusRandomQuestionsSection))
            }
            
            //Remove items from equation array
            
            removeItemsFromEquationArray(difference)
            
            //Update Table View Rows
            
            tableViewSetBonus.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
            
        }else if equationArray.count < numOfQuestions{
        
            //Create Index Path Array
            
            for i in 1...difference{
                row = (equationArray.count + i)
                indexPaths.append(NSIndexPath(forRow: row, inSection: bonusRandomQuestionsSection))
            }
            
            //Add items to equation array
            appendEquationArray(difference)
            
            tableViewSetBonus.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        }
    }
    
    func createRandomEquations(sender: UIButton){
        
        //Clear Array
        
        equationArray = []
        
        //Append Equation Array
        
        appendEquationArray(numOfQuestions)
        
        self.tableView.reloadData()
    }
    
    func appendEquationArray(items: Int){
        
        var firstNum: String
        var secondNum: String
        var operatorOption: String
        var index: Int = 0
        let lower: UInt32 = 1
        var index2: Int = 0

        while index2<items
        {
            
            // 1
            if lockFirstNumber{
                firstNum = String(maxNumber1st)
            }else{
                firstNum = String(arc4random_uniform(maxNumber1st - lower) + lower)
            }
            
            if lockSecondNumber{
                secondNum = String(maxNumber2nd)
            }else{
                secondNum = String(arc4random_uniform(maxNumber2nd - lower) + lower)
            }
            
            if operatorArray.count > 0{
                index = Int(arc4random_uniform(UInt32(operatorArray.count)) + lower)
                operatorOption = operatorArray[index-1]
            }else{
                operatorOption = "+"
            }
            equationArray.append([firstNum, operatorOption, secondNum])
            
            index2 += 1
        }
        
    
        //Save Equation Array
        let equationData = NSKeyedArchiver.archivedDataWithRootObject(equationArray)
        userDefaults.setObject(equationData, forKey: UserDefaults.key.bonusQuestions.rawValue)
    }
    
    func removeItemsFromEquationArray(items: Int){
        
        var index = 0
        while index < items{
            equationArray.removeLast()
            index += 1
        }
        
        //Save Equation Array
        let equationData = NSKeyedArchiver.archivedDataWithRootObject(equationArray)
        userDefaults.setObject(equationData, forKey: UserDefaults.key.bonusQuestions.rawValue)
    }
    

    //MARK: Action Sheets
    
    //Prevent Keyboard from appearing
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    
        if textField.tag == 3{
            ShowOperatorActionSheet(textField)
            return false
        }else{
            return true
        }
    }
    
    func ShowOperatorActionSheet(sender: UITextField)
    {
        
        let operatorOption = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let addition = UIAlertAction(title: "+", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.text = "+"
            self.updateEquationArray(sender, column: 1)
        })
        
        let subtraction = UIAlertAction(title: "-", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.text = "-"
            self.updateEquationArray(sender, column: 1)
        })
        
        let multiply = UIAlertAction(title: "×", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.text = "×"
            self.updateEquationArray(sender, column: 1)

        })
        
        let divide = UIAlertAction(title: "÷", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.text = "÷"
            self.updateEquationArray(sender, column: 1)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        operatorOption.addAction(addition)
        operatorOption.addAction(subtraction)
        operatorOption.addAction(multiply)
        operatorOption.addAction(divide)
        operatorOption.addAction(cancelAction)
        
        self.presentViewController(operatorOption, animated: true, completion: nil)

    }
    

    func updateEquationArray(sender: UITextField, column: Int){
        
        let cell = sender.superview?.superview as! BonusQuestionEquationTableViewCell
        let textIndexPath = self.tableView.indexPathForCell(cell)
        
        equationArray[textIndexPath!.row-1][column] = sender.text!
    }
    
    //MARK: Touch Function
    
    func addTapGesture(sender: UITextField){
        
        if let localTap: UITapGestureRecognizer = tap{
            view.removeGestureRecognizer(localTap)
        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap!)
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        
        if let localTap: UITapGestureRecognizer = tap{
            view.removeGestureRecognizer(localTap)
        }
        
        view.endEditing(true)
    }
    
    //MARK: User Defaults

    let userDefaults = NSUserDefaults.standardUserDefaults()
    let keySetBonusLabel: String = "keySetBonusLabel"
    let keyNumOfEquationsText: String = "keyNumOfEquationsText"
    let keyBonusQuestionQty: String = "keyBonusQuestionQty"
    let keySliderValue1stNumber: String = "SettingsViewController.sliderKey"
    let keySliderValue2ndNumber: String = "sliderKey2"
    let keyLock1stNum: String = "Lock1Key"
    let keyLock2ndNum: String = "Lock2Key"
    let keyOperatorArray: String = "keyOperatorArray"
    
    func getUserSettings(){
        
        //Is Bonus On?
        
        bonusOn = self.userDefaults.boolForKey(UserDefaults.key.setBonusQuestion.rawValue)
        
        //Is Bonus Timed?
        
        isTimed = self.userDefaults.boolForKey(UserDefaults.key.timeText.rawValue)
        
        //Time as String
        
        if let value = self.userDefaults.stringForKey(UserDefaults.key.timeText.rawValue){
            timeText = value
        }else{
            timeText = "5"
        }
        
        //Trigger
        
        if let value = self.userDefaults.stringForKey(UserDefaults.key.triggerText.rawValue){
            trigger = value
        }else{
            trigger = "5"
        }
        //Number of Equations
        
        if let value = userDefaults.stringForKey(keyNumOfEquationsText){
            numOfQuestions = Int(value)!
        }else
        {
            numOfQuestions = 1
        }
        //Max Numbers (from Settings' Sliders)
        
        if let value = userDefaults.stringForKey(keySliderValue1stNumber){
            maxNumber1st = UInt32(value)!
        }else{
            maxNumber1st = 9
        }
        
        if let value = userDefaults.stringForKey(keySliderValue2ndNumber){
            maxNumber2nd = UInt32(value)!
        }else{
            maxNumber2nd = 9
        }
        
        //Max Number Locks
        
        lockFirstNumber = userDefaults.boolForKey(keyLock1stNum)
        lockSecondNumber = userDefaults.boolForKey(keyLock2ndNum)
        
        
        // Equation(s) Array
        
        if let value = userDefaults.objectForKey(UserDefaults.key.bonusQuestions.rawValue) as? NSData{
            equationArray = (NSKeyedUnarchiver.unarchiveObjectWithData(value) as? [[String]])!
        }
        
        //Operator Array
        
        if let value = userDefaults.objectForKey(keyOperatorArray) as? NSData{
            operatorArray = (NSKeyedUnarchiver.unarchiveObjectWithData(value) as? [String])!
        }
        
        //Selected Type and Complication
        
        if let value = userDefaults.objectForKey(UserDefaults.key.selectedTypeBonus.rawValue) as? Int{
            selectedType = value
        }
        
        if let value = userDefaults.objectForKey(UserDefaults.key.selectedComplication.rawValue) as? Int{
            selectedComplication = value
        }
    }
    
    func saveUserSettings(){
        
        //Bonus Status
        self.userDefaults.setObject(bonusOn, forKey: UserDefaults.key.setBonusQuestion.rawValue)
        
        //Timer Switch
        self.userDefaults.setBool(isTimed, forKey: UserDefaults.key.timeSwitch.rawValue)
        
        //Time (Seconds as String)
        self.userDefaults.setObject(timeText, forKey: UserDefaults.key.timeText.rawValue)
        
        //Trigger
        self.userDefaults.setObject(trigger, forKey: UserDefaults.key.triggerText.rawValue)
        
        //Number of Bonus Questions
        userDefaults.setObject(numOfQuestions, forKey: keyNumOfEquationsText)
        
        //Equation Array
        let equationData = NSKeyedArchiver.archivedDataWithRootObject(equationArray)
        userDefaults.setObject(equationData, forKey: UserDefaults.key.bonusQuestions.rawValue)
        
        //Type and Complication
        
        userDefaults.setObject(selectedType, forKey: UserDefaults.key.selectedTypeBonus.rawValue)
        
        userDefaults.setObject(selectedComplication, forKey: UserDefaults.key.selectedComplication.rawValue)
    }

}

extension SetBonuesQuestionTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        switch collectionView.tag{
            case 1:
                return mathEquations.numberOfTypes
            case 2:
                return complications.items.count
            default:
                return 10
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("genericCell", forIndexPath: indexPath) as! GenericCollectionViewCell
        
        cell.cellImage.layer.cornerRadius = cell.cellImage.layer.bounds.width/2
        cell.cellImage.layer.masksToBounds = true
        cell.cellImage.layer.borderColor = colors.primaryColor[0]?.CGColor
        cell.cellImage.layer.borderWidth = 1.0
        
        switch collectionView.tag{
         
        case 1:
            
            if let type = mathEquations.convertIntToType(indexPath.row){
                cell.cellLabel.text = type.description().uppercaseString
            }else{
                cell.cellLabel.text = "ERROR!"
            }
        
            if selectedType == indexPath.item{
                collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                
                cell.isSelectedCell(true)
            }
            
        case 2:
            
            cell.cellLabel.text = complications.items[indexPath.row].title
            
            if selectedComplication == indexPath.item{
                
                collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                
                cell.isSelectedCell(true)
            }
            
        default:
            break
        }
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GenericCollectionViewCell
        
        cell.isSelectedCell(true)
        
        switch collectionView.tag{
        case 1:
            selectedType = indexPath.item
        case 2:
            selectedComplication = indexPath.item
        default:
            break
        }
        
        saveUserSettings()
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? GenericCollectionViewCell
        
        if cell != nil{
            cell!.isSelectedCell(false)
        }
    }
}



