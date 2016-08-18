//
//  PrizeTableViewController2.swift
//  JackieWWDC
//
//  Created by Mark Eaton on 6/16/15.
//  Copyright © 2015 Eaton Productions. All rights reserved.
//

import UIKit



class SettingsViewController2: UITableViewController, UITextFieldDelegate {

    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    //MARK: Class Declarations

    var user = UserDefaults()
    var colors = Colors()
    var calculator = Calculator()
    var themes: [Theme] = []
    
    let type = Type()
    var types: [Type] = []
    var countingType = CountingType()
    var basicType = BasicType()
    var bondsType = BondsType()
    var fractionsType = FractionsType()

    //MARK: UI Elements
    
    var navBar: UINavigationBar!
    
    //MARK: User Setting Variables
    
    var selectedType = Type()
    var selectedTypeIndex = 0{
        didSet{
            switch selectedTypeIndex{
            case 0:
                selectedType = CountingType()
            case 1:
                selectedType = BasicType()
            case 2:
                selectedType = BondsType()
            case 3:
                selectedType = FractionsType()
            default:
                break
            }
            userDefaults.setInteger(selectedTypeIndex, forKey: UserDefaults.key.selectedType.rawValue)
        }
    }
    
    var selectedTypeChanged = false
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
            
            userDefaults.setInteger(selectedThemeIndex, forKey: UserDefaults.key.selectedTheme.rawValue)
        }
    }
    
    //MARK: Selected Type Index (Used as tag)
    
    var typeSectionIndex = 0
    var themeSectionIndex = 0
    var calcObjIndex = 0
    
    //MARK: Counting Variables

    var minTextField: UITextField?
    var maxTextField: UITextField?
    
    var maxValue: Int?
    var minValue: Int?

    var countingMinLock: Double?
    var countingMaxLock: Double?
    
    //MARK: Basic Variables
    
    var additionOn: Bool = false
    var subtractionOn: Bool = false
    var multiplicationOn: Bool = false
    var divideOn: Bool = false
    var randomTermOn: Bool = false{
        didSet{
            calculator.randomTermOn = randomTermOn
        }
    }
    var numberOfTerms = 1{
        didSet{
            userDefaults.setInteger(numberOfTerms, forKey: UserDefaults.key.numberOfTerms.rawValue)
            updateBasic()
            let indexPath = NSIndexPath(forRow: 1, inSection: calcObjIndex)
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                let collectionViewCell = cell as? MinMaxTableViewCell
                let collectionView = collectionViewCell?.collectionView
                collectionView?.reloadSections(NSIndexSet(index: 0))
            }
        }
    }
    var calcObjs: [CalcObj] = []

    //MARK: Night Mode
    
    var colorSelection: Int = 0
    
    //MARK: Tableview Row Height

    //MARK: Selected Type Enum
    
    let minimumSectionQty: Int = 3
   
    //Gestures:
    
    var tap: UITapGestureRecognizer!
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserDefaults()
        
        let navController = self.navigationController as? MainNavigationController
        navBar = navController?.navigationBar
        
        navController?.navProgressBar?.hidden = true
        
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        themes.append(Ocean())
        themes.append(Space())
        themes.append(Ocean())
        themes.append(Ocean())
        
        types.append(countingType)
        types.append(basicType)
        types.append(bondsType)
        types.append(fractionsType)
        
        applyImageViewToBackgroundView()
        updateUI()
        
        tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 1))
        
        //Register Header Nib
        
        let headerNib = UINib(nibName: "HeaderView", bundle: nil)
        tableView.registerNib(headerNib, forHeaderFooterViewReuseIdentifier: "HeaderView")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        let mainVC = navigationController?.viewControllers.first as! MainTableViewController
        calculator = mainVC.calculator
        
        getUserDefaults()
        updateUI()
        selectedTypeChanged = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)
        dismissKeyboard()
        saveUserDefaults()
    }
    
   //MARK: Tableview Lifecycle
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        let numberOfSections: Int
        
        numberOfSections = selectedType.numberOfSections
        themeSectionIndex = numberOfSections - 1
        
        return numberOfSections
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return selectedType.numberOfRows[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        switch selectedType.type{
            
        case .counting:
            
            switch indexPath.section{
            case 0:
                return collectionViewInTableViewCell(indexPath)
            case 1:
                return createGenericLabelAndTextCell(indexPath)
            default:
                return collectionViewInTableViewCell(indexPath)
            }
        
        case .bonds:
            
            switch indexPath.section{
            case 0:
                return collectionViewInTableViewCell(indexPath)
            case 1:
                return createGenericLabelAndTextCell(indexPath)
            default:
                return collectionViewInTableViewCell(indexPath)
            }
            
        case .basic:
            
            calcObjIndex = 1
            
            switch indexPath.section{
            case 0:
                return collectionViewInTableViewCell(indexPath)
            case 1:
                switch indexPath.row{
                case 0:
                    let cell = tableView.dequeueReusableCellWithIdentifier("genericLabelAndTextCell", forIndexPath: indexPath) as! GenericLabelAndTextTableViewCell
                
                    cell.selectionStyle = .None
                    cell.contentView.backgroundColor = selectedTheme.tableViewCellBackgroundColor
                    cell.backgroundColor = selectedTheme.tableViewCellBackgroundColor
                    
                    cell.iconView.backgroundColor = selectedTheme.tableViewIconColor
                    
                    cell.iconLabel.font = UIFont(name: (cell.iconLabel.font?.fontName)!, size: 8.0)
                    let fontSub = UIFont(name: (cell.iconLabel.font?.fontName)!, size: 5.0)
                    let str = NSMutableAttributedString(string: "n1+n2")
                    
                    str.addAttributes([NSFontAttributeName:fontSub!,NSBaselineOffsetAttributeName:-2], range: NSRange(location: 1,length: 1))
                    str.addAttributes([NSFontAttributeName:fontSub!,NSBaselineOffsetAttributeName:-2], range: NSRange(location: 4,length: 1))
                    
                     //mutableString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:5], range: NSRange(location: termId.characters.count - 2, length: 2))
                    
                    cell.iconLabel.attributedText = str
                    cell.iconLabel.textColor = UIColor.whiteColor()
                    
                    cell.cellLabel.text! = "Number of Terms"
                    cell.cellLabel.textColor = UIColor.whiteColor()
                    
                    cell.cellTextField.text! = numberOfTerms.description
                    cell.cellTextField.tag = 20
                    cell.cellTextField.delegate = self
                    cell.cellTextField.textColor = selectedTheme.tableViewCellSelectableTextColor
            
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCellWithIdentifier("minMaxCollectionView", forIndexPath: indexPath) as! MinMaxTableViewCell
                    cell.minIcon.backgroundColor = selectedTheme.tableViewIconColor
                    cell.maxIcon.backgroundColor = selectedTheme.tableViewIconColor
            
                    return cell
                default:
                    break
                }
            case 2:
                
               let cell = tableView.dequeueReusableCellWithIdentifier("labelWithSwitchSingle", forIndexPath: indexPath) as! LabelWithSwitchSingleTableViewCell
               
               cell.selectionStyle = .None
               
               cell.cellSwitch.onTintColor = selectedTheme.tableViewSwitchOnTintColor
               cell.cellSwitch.tintColor = selectedTheme.tableViewSwitchTintColor
               cell.cellSwitch.addTarget(self, action: #selector(operatorSwitchValueChanged), forControlEvents: .ValueChanged)
               
               cell.cellLabel.textColor = selectedTheme.tableViewCellTextColor
               cell.iconView.backgroundColor = selectedTheme.tableViewIconColor
               cell.iconLabel.font = UIFont(name: (cell.iconLabel.font?.fontName)!, size: 25.0)
               
               switch indexPath.row{
               case 0:
                cell.cellLabel.text = ""
                cell.iconLabel.text = "+"
                cell.cellSwitch.on = additionOn
                cell.cellSwitch.tag = indexPath.row
               case 1:
                cell.cellLabel.text = ""
                cell.iconLabel.text = "-"
                cell.cellSwitch.on = subtractionOn
                cell.cellSwitch.tag = indexPath.row
               case 2:
                cell.cellLabel.text = ""
                cell.iconLabel.text = "×"
                cell.cellSwitch.on = multiplicationOn
                cell.cellSwitch.tag = indexPath.row
               case 3:
                cell.cellLabel.text = ""
                cell.iconLabel.text = "÷"
                cell.cellSwitch.on = divideOn
                cell.cellSwitch.tag = indexPath.row
               case 4:
                cell.cellLabel.text = "Random Term"
                cell.iconLabel.text = "1+_"
                cell.iconLabel.font = UIFont(name: (cell.iconLabel.font?.fontName)!, size: 10.0)
                cell.cellSwitch.on = randomTermOn
                cell.cellSwitch.tag = indexPath.row
               default:
                break
               }
                return cell
            default:
                return collectionViewInTableViewCell(indexPath)
            }
            
        case .fractions:
            switch indexPath.section{
            case 0:
                return collectionViewInTableViewCell(indexPath)
            case 1:
                return createGenericLabelAndTextCell(indexPath)
            default:
                return collectionViewInTableViewCell(indexPath)
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("genericLabelAndTextCell", forIndexPath: indexPath) as! GenericLabelAndTextTableViewCell
        cell.cellLabel.text! = "Number of Items"
        cell.cellTextField.text! = "1"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //guard let tableViewCell = cell as? CollectionViewInTableViewCell else { return }
        
        //tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
        
        if let collectionViewInTableViewCell = cell as? CollectionViewInTableViewCell{
            collectionViewInTableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
        }
        
        if let collectionViewInTableViewCell = cell as? MinMaxTableViewCell{
            collectionViewInTableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return selectedType.rowHeights[indexPath.section][indexPath.row]
    }
    
    //MARK: Tableview Header
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! HeaderCell
        
        let cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier("HeaderView") as! HeaderView
        
        cell.headerView.backgroundColor = selectedTheme.tableViewHeaderViewBackgroundColor
        
        cell.label.textColor =  selectedTheme.tableViewHeaderViewTextColor
        cell.label.text = selectedType.headerText[section]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return type.genericHeaderHeight
    }
    
    //MARK: Tableview Functions
    
    private func collectionViewInTableViewCell(indexPath: NSIndexPath) -> CollectionViewInTableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("collectionViewInTableViewCell", forIndexPath: indexPath) as! CollectionViewInTableViewCell
        return cell
    }
    
    func dismissKeyboard(){
        view.removeGestureRecognizer(tap)
        view.endEditing(true)
    }
    
    private func createGenericLabelAndTextCell(indexPath: NSIndexPath) ->GenericLabelAndTextTableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("genericLabelAndTextCell", forIndexPath: indexPath) as! GenericLabelAndTextTableViewCell
        
        cell.cellTextField.delegate = self
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        
        switch selectedType.type{
        case .counting, .bonds, .fractions:
            
            //Format Cell Label and Text Field
            cell.cellLabel.text = ""
            cell.cellLabel.textColor = selectedTheme.tableViewCellTextColor
            cell.iconLabel.text = countingType.labelText[indexPath.section][indexPath.row]
            cell.iconView.backgroundColor = selectedTheme.tableViewIconColor    
            
            cell.cellTextField.tag = indexPath.row + 1
            cell.cellTextField.textColor = selectedTheme.tableViewCellSelectableTextColor
            
            //Set Min & Max Values
            switch indexPath.row{
            case 0:
                cell.cellTextField.text = minValue?.description
            default:
                cell.cellTextField.text = maxValue?.description
            }
        
        default:
            break
        }
        
        return cell
    }

    //MARK: TextField Delegate Methods
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //100-199 - Operator Collection View Cell
    
        switch textField.tag{
        case 100...199:
            //showOperatorActionSheet(textField)
            return false
        default:
            return true
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        view.addGestureRecognizer(tap)
        textField.text = ""
        
    }

    func keyboardWillShow(){
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
  
        let value: Int
        
        //1-10: Min(1), Max(2)
        //20-30: Number of Items
        //200+ - Min Collection View
        //300+ - Max Collection View
        
        if textField.text == ""{
            value = 0
            textField.text = value.description
        }else{
            value = Int(textField.text!)!
        }
        
        switch textField.tag{
        case 1: //MIN
            
            if value >= Int(maxValue!.description){
                textField.text = (Int(maxValue!.description)! - 1).description
            }
            if value < 0{
                textField.text = "0"
            }
            
            minValue = Int(textField.text!)
            userDefaults.setInteger(minValue!, forKey: UserDefaults.key.minValue.rawValue)
            
        case 2: //MAX
            if value < Int(maxValue!.description){
                textField.text = (Int(minValue!.description)! + 1).description
            }
            if value > 999{
                textField.text = "999"
            }
            
            maxValue = Int(textField.text!)
            userDefaults.setInteger(maxValue!, forKey: UserDefaults.key.maxValue.rawValue)
            
        case 20: //Number of Terms
            if value < 2{
                textField.text = "2"
            }else if value > 5{
                textField.text = "5"
            }
            numberOfTerms = Int(textField.text!)!
        case 200...299:
            self.calcObjs[textField.tag - 200].min = Int(textField.text!)!
        case 300...399:
            if value > 100{
                textField.text = "100"
            }
            self.calcObjs[textField.tag - 300].max = value
        default:
            break
        }
    }

    //MARK - UI Updates
    
    func updateUI(){
        
        //Update Navigation Bar
        self.title = "Settings"
    
        //Clear Bar
        navBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = nil
        navBar.backgroundColor = nil
        
        //Apply Bar Style
        navBar.barStyle = selectedTheme.navBarStyle
        navBar.tintColor = selectedTheme.navBarTintColor
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: selectedTheme.navBarTintColor]
    }

    //MARK: Targets - Counting
    
    //MARK: Targets - Basic
    
    func operatorSwitchValueChanged(sender: UISwitch){
        
        var key = ""
        var op: Calculator.CalcOperator = .Add
        
        switch sender.tag{
        case 0:
            additionOn = sender.on
            key = UserDefaults.key.switchAddition.rawValue
            op = .Add
        case 1:
            subtractionOn = sender.on
            key = UserDefaults.key.switchSubtraction.rawValue
            op = .Subtract
        case 2:
            multiplicationOn = sender.on
            key = UserDefaults.key.switchMultiplication.rawValue
            op = .Multiply
        case 3:
            divideOn = sender.on
            key = UserDefaults.key.switchDivider.rawValue
            op = .Divide
        case 4:
            randomTermOn = sender.on
            key = UserDefaults.key.randomTerm.rawValue
        default:
            break
        }
        
        //Add or Remove from Operator Array (Operator Switches Only!)
        
        if sender.tag < 4{
            if sender.on{
                if calculator.operatorArray.indexOf(op) == nil{
                    calculator.operatorArray.append(op)
                }
            }else{
                if let index = calculator.operatorArray.indexOf(op){
                    calculator.operatorArray.removeAtIndex(index)
                }
            }
        }
        
        //Save to User Defaults
        userDefaults.setBool(sender.on, forKey: key)
    }
    
    func showOperatorActionSheet(sender: UIButton)
    {
        
        let operatorOption = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    
        let shuffle = UIAlertAction(title: "Shuffle", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("s", forState: .Normal)
            self.calcObjs[sender.tag].op = sender.titleForState(.Normal)!
        })
        
        let addition = UIAlertAction(title: "+", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("+", forState: .Normal)
            self.calcObjs[sender.tag].op = sender.titleForState(.Normal)!
        })
        
        let subtraction = UIAlertAction(title: "-", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("-", forState: .Normal)
            self.calcObjs[sender.tag].op = sender.titleForState(.Normal)!
        })
        
        let multiply = UIAlertAction(title: "×", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("×", forState: .Normal)
            self.calcObjs[sender.tag].op = sender.titleForState(.Normal)!
        })
        
        let divide = UIAlertAction(title: "÷", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            sender.setTitle("÷", forState: .Normal)
            self.calcObjs[sender.tag].op = sender.titleForState(.Normal)!
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        operatorOption.addAction(shuffle)
        operatorOption.addAction(addition)
        operatorOption.addAction(subtraction)
        operatorOption.addAction(multiply)
        operatorOption.addAction(divide)
        operatorOption.addAction(cancelAction)
    
        self.presentViewController(operatorOption, animated: true, completion: nil)
    }
    
    func lockButtonPressed(sender: UIButton){
        
        let image: UIImage!
        
        if calcObjs[sender.tag].locked{
            calcObjs[sender.tag].locked = false
            image = UIImage(named: "unlockImage")
            sender.setImage(image, forState: .Normal)
        }else{
            calcObjs[sender.tag].locked = true
            image = UIImage(named: "lockImage")
            sender.setImage(image, forState: .Normal)
        }
    }
    
    //MARK: Methods - Basic
    
    func updateBasic(){
        
        let difference = abs(calcObjs.count - numberOfTerms)
        
        if calcObjs.count < numberOfTerms{
            //Append items to Array
            for _ in 1...difference{
                let mmo = CalcObj(id: calcObjs.count, min: 0, max: 10, locked: false, op: "s")
                calcObjs.append(mmo)
            }
            
        }else{
            //Remove items from Array
            if difference != 0{
                for _ in 1...difference{
                    calcObjs.removeLast()
                }
            }
        }
        
        //Update Basic (calc) model in Main VC
        
        calculator.calcObjs = calcObjs
    }
    
    //MARK: User Defaults
    
    func getUserDefaults(){
    
        
        //Selected Theme Index
        selectedThemeIndex = userDefaults.integerForKey(UserDefaults.key.selectedTheme.rawValue)
        
        //Selected Type
        
        selectedTypeIndex = userDefaults.integerForKey(UserDefaults.key.selectedType.rawValue)
   
        //Color Selection
        
        if let value = userDefaults.stringForKey(UserDefaults.key.colorSelection.rawValue){
            colorSelection = Int(value)!
        }
        
        //Min, Max Values
        
        minValue = userDefaults.integerForKey(UserDefaults.key.minValue.rawValue)
        maxValue = userDefaults.integerForKey(UserDefaults.key.maxValue.rawValue)
    
        //Operator Switches
        
        additionOn = userDefaults.boolForKey(UserDefaults.key.switchAddition.rawValue)
        subtractionOn = userDefaults.boolForKey(UserDefaults.key.switchSubtraction.rawValue)
        multiplicationOn = userDefaults.boolForKey(UserDefaults.key.switchMultiplication.rawValue)
        divideOn = userDefaults.boolForKey(UserDefaults.key.switchDivider.rawValue)
        
        //Number of Items
        
        if userDefaults.integerForKey(UserDefaults.key.numberOfTerms.rawValue) < 2{
            numberOfTerms = 2
        }else{
            numberOfTerms = userDefaults.integerForKey(UserDefaults.key.numberOfTerms.rawValue)
        }
        
        //Calc Objects
        let basicData = userDefaults.objectForKey(UserDefaults.key.calcObj.rawValue) as? NSData
        
        if basicData != nil {
            calcObjs = (NSKeyedUnarchiver.unarchiveObjectWithData(basicData!) as? [CalcObj])!
        }
        
        //Random Terms:
        randomTermOn = userDefaults.boolForKey(UserDefaults.key.randomTerm.rawValue)
    }
    
    func saveUserDefaults(){
     
        //Min, Max and Operator
        
        let basicData = NSKeyedArchiver.archivedDataWithRootObject(calcObjs)
        userDefaults.setObject(basicData, forKey: UserDefaults.key.calcObj.rawValue)
    }
}

//MARK: Collection View Extension

extension SettingsViewController2: UICollectionViewDelegate, UICollectionViewDataSource {
 
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView.tag{
            case typeSectionIndex:
                return types.count
            case themeSectionIndex:
                return 4
            case calcObjIndex:
                return numberOfTerms
            default:
                return 10
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag{
        
        case typeSectionIndex:
            
            switch indexPath.item{

            case 0:
                
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("countingCollectionViewCell", forIndexPath: indexPath) as! CountingCollectionViewCell
                
                cell.cellView.layer.cornerRadius = cell.cellView.layer.bounds.width/2
                cell.cellView.layer.masksToBounds = true
                cell.cellView.layer.borderColor = selectedTheme.collectionViewCellBorderColor.CGColor
                cell.cellView.layer.borderWidth = selectedTheme.collectionViewCellBorderWidth
                cell.cellView.backgroundColor = UIColor.clearColor()

                cell.cellLabel.textColor = selectedTheme.collectionViewCellTextColor
                
                return cell
                
            case 1:
                
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("basicCollectionViewCell", forIndexPath: indexPath) as! BasicCollectionViewCell
                
                cell.cellView.layer.cornerRadius = cell.cellView.layer.bounds.width/2
                cell.cellView.layer.masksToBounds = true
                cell.cellView.layer.borderColor = selectedTheme.collectionViewCellBorderColor.CGColor
                cell.cellView.layer.borderWidth = selectedTheme.collectionViewCellBorderWidth
                cell.cellView.backgroundColor = UIColor.clearColor()
                
                cell.cellLabel.textColor = selectedTheme.collectionViewCellTextColor
                
                return cell
                
            case 2:
                
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("bondsCollectionViewCell", forIndexPath: indexPath) as! BondsCollectionViewCell
                
                //Set initial value(s)
                cell.initialBorderColor = selectedTheme.collectionViewCellBorderColor.CGColor
                
                //Format Cell View & Label
                cell.cellView.layer.cornerRadius = cell.cellView.layer.bounds.width/2
                cell.cellView.layer.masksToBounds = true
                cell.cellView.layer.borderColor = selectedTheme.collectionViewCellBorderColor.CGColor
                cell.cellView.layer.borderWidth = selectedTheme.collectionViewCellBorderWidth
                cell.cellView.backgroundColor = UIColor.clearColor()
                
                cell.cellLabel.textColor = selectedTheme.collectionViewCellTextColor
                
                //Format Bubble Views
                cell.viewLargeBubble.backgroundColor = UIColor.clearColor()
                cell.viewLargeBubble.layer.masksToBounds = true
                cell.viewLargeBubble.layer.cornerRadius = cell.viewLargeBubble.bounds.width/2
                cell.viewLargeBubble.layer.borderWidth = 2.0
                cell.viewLargeBubble.layer.borderColor = selectedTheme.collectionViewCellBorderColor.CGColor
                
                cell.viewSmallBubbleOne.backgroundColor = UIColor.clearColor()
                cell.viewSmallBubbleOne.layer.masksToBounds = true
                cell.viewSmallBubbleOne.layer.cornerRadius = cell.viewSmallBubbleOne.bounds.width/2
                cell.viewSmallBubbleOne.layer.borderWidth = 2.0
                cell.viewSmallBubbleOne.layer.borderColor = selectedTheme.collectionViewCellBorderColor.CGColor
                
                cell.viewSmallBubbleTwo.backgroundColor = UIColor.clearColor()
                cell.viewSmallBubbleTwo.layer.masksToBounds = true
                cell.viewSmallBubbleTwo.layer.cornerRadius = cell.viewSmallBubbleTwo.bounds.width/2
                cell.viewSmallBubbleTwo.layer.borderWidth = 2.0
                cell.viewSmallBubbleTwo.layer.borderColor = selectedTheme.collectionViewCellBorderColor.CGColor
    
                return cell
                
            default:

                //Fractions
                
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("fractionsCollectionViewCell", forIndexPath: indexPath) as! FractionsCollectionViewCell
                
                cell.cellView.layer.cornerRadius = cell.cellView.layer.bounds.width/2
                cell.cellView.layer.masksToBounds = true
                cell.cellView.layer.borderColor = selectedTheme.collectionViewCellBorderColor.CGColor
                cell.cellView.layer.borderWidth = selectedTheme.collectionViewCellBorderWidth
                cell.cellView.backgroundColor = UIColor.clearColor()
                
                cell.cellLabel.textColor = selectedTheme.collectionViewCellTextColor
                
                return cell
            
            }
            
        case calcObjIndex:
            
                //Format Min/Max Cell
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("minMaxCell", forIndexPath: indexPath) as! MinMaxCollectionViewCell
                
                let font = UIFont(name: (cell.termID.font?.fontName)!, size: 10.0)
                let fontSuper = UIFont(name: (cell.termID.font?.fontName)!, size: 6.0)
                let termId: String
                let mutableString: NSMutableAttributedString
                
                switch indexPath.item{
                case 0:
                    termId = "1st"
                    mutableString = NSMutableAttributedString(string: termId, attributes: [NSFontAttributeName:font!])
                case 1:
                    termId = "2nd"
                    mutableString = NSMutableAttributedString(string: termId, attributes: [NSFontAttributeName:font!])
                case 2:
                    termId = "3rd"
                    mutableString = NSMutableAttributedString(string: termId, attributes: [NSFontAttributeName:font!])
                default:
                    termId = (indexPath.item + 1).description + "th"
                    mutableString = NSMutableAttributedString(string: termId, attributes: [NSFontAttributeName:font!])
                }
                
                mutableString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:5], range: NSRange(location: termId.characters.count - 2, length: 2))
                
                cell.termID.attributedText = mutableString
                
                let index = (indexPath.item)
                
                cell.minTextField.tag = 200 + (index)
                cell.minTextField.delegate = self
                cell.minTextField.text = calcObjs[index].min.description
                cell.minTextField.textColor = selectedTheme.collectionViewCellSelectableTextColor
                
                cell.maxTextField.tag = 300 + (index)
                cell.maxTextField.delegate = self
                cell.maxTextField.text = calcObjs[index].max.description
                cell.maxTextField.textColor = selectedTheme.collectionViewCellSelectableTextColor
                
                //Format Operator Button
                cell.operatorButton.setTitleColor(selectedTheme.collectionViewCellSelectableTextColor, forState: .Normal)
                cell.operatorButton.addTarget(self, action: #selector(showOperatorActionSheet), forControlEvents: .TouchUpInside)
                cell.operatorButton.tag = indexPath.item
                cell.operatorButton.setTitle(calcObjs[indexPath.item].op, forState: .Normal)
                
                //Hide Operator Button if last term
                if indexPath.item + 1 == calcObjs.count{
                    cell.operatorButton.hidden = true
                }else{
                    cell.operatorButton.hidden = false
                }
                
                //Format Lock Button
                
                cell.lockButton.tag = indexPath.item
                cell.lockButton.backgroundColor = UIColor.clearColor()
                cell.lockButton.addTarget(self, action: #selector(lockButtonPressed), forControlEvents: .TouchDown)
                
                if calcObjs[indexPath.item].locked{
                    cell.lockButton.setImage(UIImage(named: "lockImage"), forState: .Normal)
                }else{
                    cell.lockButton.setImage(UIImage(named: "unlockImage"), forState: .Normal)
                }
                
                return cell
            
        case themeSectionIndex:
            
            switch indexPath.item{
            case 0:
                
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("oceanCollectionViewCell", forIndexPath: indexPath) as! OceanCollectionViewCell

                cell.cellView.layer.cornerRadius = cell.cellView.layer.bounds.width/2
                cell.cellView.layer.masksToBounds = true
                cell.cellView.layer.borderColor = selectedTheme.collectionViewCellBorderColor.CGColor
                cell.cellView.layer.borderWidth = selectedTheme.collectionViewCellBorderWidth
                cell.cellView.backgroundColor = UIColor.clearColor()
                
                cell.cellLabel.textColor = selectedTheme.collectionViewCellTextColor
                
                cell.oceanView.waveFillColor = selectedTheme.tableViewHeaderViewBackgroundColor.CGColor
                
                return cell
            
            case 1:
                
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("spaceCollectionViewCell", forIndexPath: indexPath) as! SpaceCollectionViewCell
                
                cell.cellView.layer.cornerRadius = cell.cellView.layer.bounds.width/2
                cell.cellView.layer.masksToBounds = true
                cell.cellView.layer.borderColor = selectedTheme.collectionViewCellBorderColor.CGColor
                cell.cellView.layer.borderWidth = selectedTheme.collectionViewCellBorderWidth
                cell.cellView.backgroundColor = UIColor.clearColor()
                
                cell.spaceView.backgroundColor = UIColor.clearColor()
                cell.spaceView.moonColor = selectedTheme.tableViewHeaderViewBackgroundColor
                
                
                cell.cellLabel.textColor = selectedTheme.collectionViewCellTextColor
                
                return cell
                
            default:
                
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("genericCell", forIndexPath: indexPath) as! GenericCollectionViewCell
                cell.cellImage.layer.cornerRadius = cell.cellImage.layer.bounds.width/2
                cell.cellImage.layer.masksToBounds = true
                cell.cellImage.layer.borderColor = colors.primaryColor[0]?.CGColor
                cell.cellImage.layer.borderWidth = 1.0
                
                cell.cellLabel.text = themes[indexPath.item].collectionViewCellTitle
                cell.cellLabel.textColor = selectedTheme.collectionViewCellTextColor
                
                return cell
            }
            
        default:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("minMaxCell", forIndexPath: indexPath) as! MinMaxCollectionViewCell
            return cell
        }
            }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        switch collectionView.tag{
            
        case typeSectionIndex:
        
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TypeCollectionViewCell
            cell.didSelect()
            cell.startAnimation()
            
            let oldNumberOfSections = selectedType.numberOfSections
            
            if indexPath.item != selectedType.type.rawValue(){
                selectedTypeChanged = true
            }
            
            selectedTypeIndex = indexPath.item
            
            let newNumberOfSections = selectedType.numberOfSections
            
            //Reload Table Sections
            
            if newNumberOfSections > oldNumberOfSections{
                let deleteSections = NSIndexSet(indexesInRange: NSRange(location: 1,length: 2))
                let addedSections = NSIndexSet(indexesInRange: NSRange(location: 1,length: 3))
                
                tableView.beginUpdates()
                tableView.deleteSections(deleteSections, withRowAnimation: .Automatic)
                tableView.insertSections(addedSections, withRowAnimation: .Automatic)
                tableView.endUpdates()
                //tableView.reloadSections(addedSections, withRowAnimation: .Automatic)
            }else if newNumberOfSections < oldNumberOfSections{
                let deleteSections = NSIndexSet(indexesInRange: NSRange(location: 1,length: 3))
                let addedSections = NSIndexSet(indexesInRange: NSRange(location: 1,length: 2))
                
                tableView.beginUpdates()
                tableView.deleteSections(deleteSections, withRowAnimation: .Automatic)
                tableView.insertSections(addedSections, withRowAnimation: .Automatic)
                tableView.endUpdates()
                //tableView.reloadSections(addedSections, withRowAnimation: .Automatic)
            }
            
            //Update Main View View Controller
            
            let mainVC = self.navigationController?.viewControllers.first as! MainTableViewController
            
            mainVC.selectedType = selectedType.type
            mainVC.selectedTypeChanged = selectedTypeChanged
            
        case themeSectionIndex:
            switch indexPath.item{
            case 0:
                let cell = collectionView.cellForItemAtIndexPath(indexPath) as! OceanCollectionViewCell
                cell.oceanView.animate()
            case 1:
                let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SpaceCollectionViewCell
                cell.spaceView.animate()
            default:
                break
            }
            if selectedThemeIndex != indexPath.item{
                selectedThemeIndex = indexPath.item
                
                //Will reloading all sections will cancel the animation of collection view cell
                let numberOfSectionsToReload = selectedType.numberOfSections - 1
                let indexSet = NSIndexSet(indexesInRange: NSRange(location: 0,length: numberOfSectionsToReload))
                let indexPathForTableRow = NSIndexPath(forRow: 0, inSection: themeSectionIndex)
                
            
                tableView.reloadSections(indexSet, withRowAnimation: .Automatic)
                
                applyImageViewToBackgroundView()
                updateThemeTableViewRowUI(indexPathForTableRow)
                
                //Update Navbar
                navBar.barStyle = selectedTheme.navBarStyle
                navBar.tintColor = selectedTheme.navBarTintColor
                navBar.titleTextAttributes = [NSForegroundColorAttributeName: selectedTheme.navBarTintColor]
            }
            
        default:
            break
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        switch collectionView.tag{
        
        case typeSectionIndex:
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TypeCollectionViewCell
            cell?.didDeselect()
            cell?.endAnimation()
        default:
            break
        }
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        switch collectionView.tag{
        case typeSectionIndex:
            let typeCell = cell as? TypeCollectionViewCell
            typeCell?.endAnimation()
        default:
            break
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        switch collectionView.tag{
        case typeSectionIndex:
            if selectedType.type.rawValue() == indexPath.item{
                let typeCell = cell as? TypeCollectionViewCell
                typeCell?.didSelect()
                typeCell?.startAnimation()
                collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
            }
            break
        default:
            break
        }
    }
    
    func applyImageViewToBackgroundView(){
        
        //Set Background Image w/ blur effect
        tableView.backgroundView = UIImageView(image: UIImage(named: selectedTheme.backgroundImageName!))
        selectedTheme.superview = tableView.backgroundView!
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: selectedTheme.backgroundImageBlurEffect))
        blurView.frame = (tableView.backgroundView?.bounds)!
        tableView.backgroundView!.addSubview(blurView)
    }
    
    func updateThemeTableViewRowUI(indexPath: NSIndexPath){
        
        let header = tableView.headerViewForSection(indexPath.section) as? HeaderView
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? CollectionViewInTableViewCell
        
        //Format Header
        
        header?.headerView.backgroundColor = self.selectedTheme.tableViewHeaderViewBackgroundColor
        
        if let collectionView = cell?.genericCollectionView{
            
            for collectionViewCell in collectionView.visibleCells(){
                let themeCell = collectionViewCell as? ThemeCollectionViewCell
                themeCell?.cellView.layer.borderColor = selectedTheme.collectionViewCellBorderColor.CGColor
            }
        }
    }
}




