//
//  SetPrizeTableViewController.swift
//  Prize Math
//
//  Created by Mark Eaton on 1/9/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class SetPrizeTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    var colors = Colors()
    
    let sectionHeaderHeight: CGFloat = 40.0
    
    let prizeSelectRowHeight: CGFloat = 100
    let prizeDetailsRowHeight: CGFloat = 100.0
    let prizeImageRowHeight: CGFloat = 200
    
    var prizeImage: UIImageView?
    var prizeCollectionView: UICollectionView?
    var prizeTitle: UITextField?
    var prizeDescription: UITextField?
    
    var prizeType = [Prize]()

    var selectedPrizeTypeIndex: Int?{
        didSet{
            userDefaults.setObject(selectedPrizeTypeIndex?.description, forKey: keySelectedPrizeTypeIndex)
        }
    }
    
    var collectionViewOffset: Float?{
        didSet{
            userDefaults.setFloat(collectionViewOffset!, forKey: keyCollectionViewOffset)
        }
    }
    
    var initialParentalControlViewLoad: Bool = false{
        didSet{
            userDefaults.setBool(initialParentalControlViewLoad, forKey: keyInitialParentalControlViewLoad)
        }
    }
    
    var tap: UITapGestureRecognizer?
    var nightMode: Bool = false
    

    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let prize2: Prize = Prize(title: "No Nap!", prizeDescription: "Skip naptime for one day.", imagePath: "prizeCollectionViewCellImageLarge.png")
        
        prize2.isDefaultPrize = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        DismissKeyboard()
        savePrizeType()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false) //Must call or textfields won't autoscroll
    
        GetUserSettings()
        updateUI()
        tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("turnOnPrizeCell", forIndexPath: indexPath) as! SetBonusQuestionTableViewCell
            
            cell.switchSetBonusQuestion.on = self.userDefaults.boolForKey(keySetPrize)
            
            if cell.switchSetBonusQuestion.on{
                cell.labelSetBonusQuestion.text = "ON"
            }else
            {
                cell.labelSetBonusQuestion.text = "OFF"
            }
            
            nightMode(cell.contentView)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("prizeTypeCollectionViewCell", forIndexPath: indexPath) as! PrizeTypeTableViewCell
            
            prizeCollectionView = cell.testCollectionView!
            
            if nightMode{
                prizeCollectionView?.backgroundColor = colors.nightModeViewCell
            }else{
                prizeCollectionView?.backgroundColor = colors.nightModeViewCellOff
            }
            
            nightMode(cell.contentView)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("prizeTitleTableViewCell", forIndexPath: indexPath) as! prizeTitleTableViewCell
        
            if prizeType.count == 0{
                cell.textFieldTitle.text = ""
                cell.textFieldDescription.text = ""
            }else{
                cell.textFieldTitle.text = prizeType[selectedPrizeTypeIndex!].title
                cell.textFieldDescription.text = prizeType[selectedPrizeTypeIndex!].prizeDescription
            }
           
            //Add targets
            
            cell.textFieldTitle.addTarget(self, action: #selector(textFieldDoneEditing), forControlEvents: .EditingDidEnd)
            cell.textFieldDescription.addTarget(self, action: #selector(textFieldDoneEditing), forControlEvents: .EditingDidEnd)
            
            cell.textFieldTitle.addTarget(self, action: #selector(addTapGesture), forControlEvents: .EditingDidBegin)
            cell.textFieldDescription.addTarget(self, action: #selector(addTapGesture), forControlEvents: .EditingDidBegin)
            
            prizeTitle = cell.textFieldTitle
            prizeDescription = cell.textFieldDescription
            
            if prizeType.count == 0{
                prizeTitle?.placeholder = "Add a Prize!"
                prizeDescription?.placeholder = ""
                prizeTitle?.userInteractionEnabled = false
                prizeDescription?.userInteractionEnabled = false
            }
    
            nightMode(cell.contentView)
            
            if nightMode{
                cell.textFieldTitle.attributedPlaceholder = NSAttributedString(string:"Enter Title",
                    attributes:[NSForegroundColorAttributeName: colors.nightModePlaceHolder])
                cell.textFieldDescription.attributedPlaceholder = NSAttributedString(string:"Enter Description",
                    attributes:[NSForegroundColorAttributeName: colors.nightModePlaceHolder])
            }else{
                cell.textFieldTitle.attributedPlaceholder = NSAttributedString(string:"Enter Title",
                    attributes:[NSForegroundColorAttributeName: colors.nightModePlaceHolderOff])
                cell.textFieldDescription.attributedPlaceholder = NSAttributedString(string:"Enter Description",
                    attributes:[NSForegroundColorAttributeName: colors.nightModePlaceHolderOff])
            }
            
            return cell

        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("prizeImageTableViewCell", forIndexPath: indexPath) as! prizeImageTableViewCell
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImageActionSheet))
            
            tap.numberOfTapsRequired = 1
            
            cell.prizeImage.addGestureRecognizer(tap)
            
            prizeImage = cell.prizeImage
            
            //Turn off user interaction if no prizes exists
            
            if prizeType.count == 0{
                prizeImage?.userInteractionEnabled = false
            }else{
                prizeImage?.userInteractionEnabled = true
            }
        
            //If no prizes exists load placeholder image, else load image at selected index.
            
            if prizeType.count == 0{
                prizeImage?.image = getPrizeImage("prizeCollectionViewCellImageLarge.png")
            }else{
                if let image = getPrizeImage(){
                    prizeImage?.image = image
                }
            }
            
            
            nightMode(cell.contentView)
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("prizeTypeCollectionViewCell", forIndexPath: indexPath) as! PrizeTypeTableViewCell
            
            nightMode(cell.contentView)
            
            return cell
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.section{
        case 1:
            return prizeSelectRowHeight
        case 2:
            return prizeDetailsRowHeight
        case 3:
            return prizeImageRowHeight
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
            
        case 0:
            cell.headerLabel.text = "STATUS"
        case 1:
            cell.headerLabel.text = "SELECT TYPE"
        case 2:
            cell.headerLabel.text = "ENTER DETAILS"
        case 3:
            cell.headerLabel.text = "SELECT IMAGE"
        default:
            cell.headerLabel.text = "ERROR!"
        }
        
        return cell
    }
    
    func addTapGesture(sender: UITextField){
        
        if let localTap: UITapGestureRecognizer = tap{
            view.removeGestureRecognizer(localTap)
            print("tap removed")
        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap!)
        print("tap added")
    }
    
    func textFieldDoneEditing(sender: UITextField){
        switch sender.tag{
        case 0:
            prizeType[selectedPrizeTypeIndex!].title = sender.text!
        case 1:
            prizeType[selectedPrizeTypeIndex!].prizeDescription = sender.text!
        default:
        break
        }
        
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        
        if let localTap: UITapGestureRecognizer = tap{
            view.removeGestureRecognizer(localTap)
            print("tap removed")
        }
        
        view.endEditing(true)
    }
    

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section{
        case 0:
            return 40
        default:
            return sectionHeaderHeight
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? PrizeTypeTableViewCell else { return }
    
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
        
        let value = userDefaults.floatForKey(keyCollectionViewOffset)
       
        dispatch_async(dispatch_get_main_queue(), {
            tableViewCell.testCollectionView.contentOffset.x = CGFloat(value)
        })
    
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
    
    //MARK: Prize Image Selection
    
    func showImageActionSheet(sender: UITapGestureRecognizer){
        
        let imagePicker = UIImagePickerController()
        
        let pictureOption = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        })
        
        let selectPhoto = UIAlertAction(title: "Select Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        pictureOption.addAction(takePhoto)
        pictureOption.addAction(selectPhoto)
        pictureOption.addAction(cancelAction)
        
        self.presentViewController(pictureOption, animated: true, completion: nil)

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        
        var imageData: NSData
        var prizeImagePath: String
        
        self.dismissViewControllerAnimated(true, completion: nil);
        
        var gotImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //Square Image
        
        gotImage = RBSquareImage(gotImage!)
        
        let newSize = CGSize(width: 175,height: 175)
        let newRect = CGRect(x: 0, y: 0, width: newSize.height, height: newSize.width)
        
        UIGraphicsBeginImageContext(newSize)
        gotImage!.drawInRect(newRect)
        gotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Compress Image
        
        imageData = UIImageJPEGRepresentation(gotImage!, 1)!
        
        prizeImagePath = "image_\(NSDate.timeIntervalSinceReferenceDate()).jpg"
        prizeType[selectedPrizeTypeIndex!].imagePath = prizeImagePath
        
        let path = self.documentsPathForFileName(prizeImagePath)
        
        imageData.writeToFile(path, atomically: true)
        
        savePrizeType()
        self.tableView.reloadData()
        
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
    
    func documentsPathForFileName(name: String) -> String {
        
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let path1 = paths.URLByAppendingPathComponent(name)
        let fullPath = path1.path!
        
        return fullPath
    }
    
    func getPrizeImage()->UIImage? {
    
        if prizeType.count == 0{
            return nil
        }else{
        
        let oldImagePath = prizeType[selectedPrizeTypeIndex!].imagePath
        let oldFullPath = self.documentsPathForFileName(oldImagePath)
        
        if let oldImageData = NSData(contentsOfFile: oldFullPath)
            {
               return UIImage(data: oldImageData)
            }else{
                return UIImage(named: oldImagePath)
            }
        }
    }
    
    func getPrizeImage(imagePath: String) ->UIImage?{
        
        let oldFullPath = self.documentsPathForFileName(imagePath)
        
        if let oldImageData = NSData(contentsOfFile: oldFullPath)
        {
            return UIImage(data: oldImageData)
        }else{
            return UIImage(named: imagePath)
        }
        
    }

    func updateUI(){
        
        //Add bar button to top bar
        
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addPrize))
        navigationItem.rightBarButtonItem = saveBarButton
        
        if nightMode{
            tableView.backgroundColor = colors.nightModeSection
        }else{
            tableView.backgroundColor = colors.nightModeSectionOff
        }
        
    }
    
    func addPrize(sender: UIBarButtonItem){
        
        //Resign First Responding before
        DismissKeyboard()
        
        //Deselect selected cell
       
        if prizeType.count != 0{
            collectionView(prizeCollectionView!, didDeselectItemAtIndexPath: NSIndexPath(forRow: selectedPrizeTypeIndex!, inSection: 0))
        }
       
        //Add new blank Prize
        let addPrize = Prize(title: "", prizeDescription: "", imagePath: "prizeCollectionViewCellImageLarge.png")
        addPrize.isDefaultPrize = false
        
        prizeType.insert(addPrize, atIndex: 0)
        
        //Insert new item in Collection View
        
        let index: [NSIndexPath] = [NSIndexPath(forRow: 0, inSection: 0)]
        prizeCollectionView?.insertItemsAtIndexPaths(index)
        
        //Select Added Prize after Reload
        selectedPrizeTypeIndex = 0
        
        //Reset Offset to Added Prize will be shown after creation
        collectionViewOffset = 0
        
        //Call DidSelect @ IndexPath
        
        collectionView(prizeCollectionView!, didSelectItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        prizeCollectionView?.selectItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: .None)
        
    }
    
    func savePrizeType(){
        //Save PrizeType Data
        let prizeTypeData = NSKeyedArchiver.archivedDataWithRootObject(prizeType)
        userDefaults.setObject(prizeTypeData, forKey: keyPrizeTypeData)
        self.userDefaults.synchronize()
    }
    
    func showCellDeleteAlert(index: [NSIndexPath], cell: testCollectionViewCell){
        
        let prizeTitle = prizeType[index[0].row].title
        
        let alertController = UIAlertController(title: "Delete Prize?", message: prizeTitle, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "Delete", style: .Default, handler: {finished in
            self.prizeType.removeAtIndex(self.selectedPrizeTypeIndex!)
            self.prizeCollectionView?.deleteItemsAtIndexPaths(index)
            
            if self.prizeType.count > 0 &&  self.selectedPrizeTypeIndex > (self.prizeType.count-1){
                self.selectedPrizeTypeIndex = self.prizeType.count-1
            }
        
            self.collectionView(self.prizeCollectionView!, didSelectItemAtIndexPath: NSIndexPath(forRow: self.selectedPrizeTypeIndex!, inSection: 0))
            self.prizeCollectionView?.selectItemAtIndexPath(NSIndexPath(forRow: self.selectedPrizeTypeIndex!, inSection: 0), animated: false, scrollPosition: .None)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: {finished in
            
            self.prizeType[self.selectedPrizeTypeIndex!].animate = false
            cell.isAnimating = false
            cell.stopRotate()
        })
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        alertController.view.tintColor = UIColor(red: 0, green: 128/255, blue: 1.0, alpha: 1.0)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: User Defaults
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let keyPrizeTitleTextField: String = "keyPrizeTitleTextField"
    let keyPrizeDescriptionTextField: String = "keyPrizeDescriptionTextField"
    let keySetPrize: String = "keySetPrize"
    let keySelectedPrizeTypeIndex: String = "keySelectedPrizeTypeIndex"
    let keyCollectionViewOffset: String = "keyCollectionViewOffset"
    let keyPrizeImagePath: String = "keyPrizeImagePath"
    let keyInitialParentalControlViewLoad: String = "keyInitialParentalControlViewLoad"
    let keyPrizeTypeData: String = "keyPrizeTypeData"
    
    func GetUserSettings(){
        
        //Initial Load (Bool)
        
        initialParentalControlViewLoad = userDefaults.boolForKey(keyInitialParentalControlViewLoad)
        
        //PrizeType Array
        
        //Load Prize Type data from user defaults
        
        if let data = userDefaults.objectForKey(keyPrizeTypeData) as? NSData{
            prizeType = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Prize])!
        }
        
        //Selected Prize Type Index
        
        if let value = userDefaults.stringForKey(keySelectedPrizeTypeIndex){
            
            if Int(value) > prizeType.count {
                selectedPrizeTypeIndex = 0
            }else if Int(value) == prizeType.count{
                selectedPrizeTypeIndex = Int(value)! - 1
            }else{
                selectedPrizeTypeIndex = Int(value)
            }
        }else
        {
            selectedPrizeTypeIndex = 0
        }
    }
}
        
extension SetPrizeTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prizeType.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("testCollectionView", forIndexPath: indexPath) as! testCollectionViewCell
        
        //Add double Tap
        
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer()
        doubleTap.numberOfTapsRequired = 2
        doubleTap.addTarget(self, action: #selector(prizeCellDoubleTapped))
                                        
        cell.testView.addGestureRecognizer(doubleTap)
        
       //Add Long Tap Gesture
      
        let longPress: CollectionViewCellLongPressGestureRecognizer = CollectionViewCellLongPressGestureRecognizer()
        longPress.tag=indexPath.row
        longPress.addTarget(self, action: #selector(collectionCellLongPressed))
        
        cell.testView.addGestureRecognizer(longPress)
        cell.prizeImage.image = getPrizeImage(prizeType[indexPath.row].imagePath)
        
       //Style Cell View Border
        
        if indexPath.row == selectedPrizeTypeIndex{
            
        prizeCollectionView?.selectItemAtIndexPath(NSIndexPath(forRow: selectedPrizeTypeIndex!, inSection: 0), animated: false, scrollPosition: .None)
            
        isSelectedCell(cell, selected: true)

        }else{
            isSelectedCell(cell, selected: false)
        }
        
        
        if prizeType[indexPath.row].animate == true{
            cell.rotate()

        }
        
        nightMode(cell.contentView)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        //Add Animation
        //print(indexPath.row.description)
        let prizeCell = cell as! testCollectionViewCell
        if prizeType[indexPath.row].animate == false{
             prizeCell.prizeImage.layer.removeAllAnimations()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //Resign First Responding before
        DismissKeyboard()
        
        var index: [NSIndexPath] = [indexPath]
        
        selectedPrizeTypeIndex = index[0].row
        
        if let cell = prizeCollectionView?.cellForItemAtIndexPath(indexPath) as? testCollectionViewCell{
            
            if prizeType[selectedPrizeTypeIndex!].animate == true{
                showCellDeleteAlert(index, cell: cell)
            }
            
            isSelectedCell(cell, selected: true)
            
        }
    
        //Set Prize text fields and:
        
        if prizeType.count != 0{
            
            prizeTitle!.text = prizeType[selectedPrizeTypeIndex!].title
            prizeTitle!.placeholder = "Enter Title"
            prizeTitle!.userInteractionEnabled = true
            
            prizeDescription!.text = prizeType[selectedPrizeTypeIndex!].prizeDescription
            prizeDescription!.placeholder = "Enter Description"
            prizeDescription!.userInteractionEnabled = true
            
            prizeImage?.userInteractionEnabled = true
        
        }else{
            
            prizeTitle!.text = ""
            prizeTitle!.placeholder = "Add a Prize!"
            prizeTitle!.userInteractionEnabled = false
            
            prizeDescription!.text = ""
            prizeDescription!.placeholder = ""
            prizeDescription!.userInteractionEnabled = false
            
            prizeImage?.image = getPrizeImage("prizeCollectionViewCellImageLarge.png")
            prizeImage?.userInteractionEnabled = false
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectedPrizeTypeIndex = indexPath.row
        
        if let cell = prizeCollectionView?.cellForItemAtIndexPath(indexPath) as? testCollectionViewCell{
            isSelectedCell(cell, selected: false)
        }
        
    }
    
    func collectionCellLongPressed(sender: CollectionViewCellLongPressGestureRecognizer){
        
        switch sender.state{
            
        case UIGestureRecognizerState.Began:
            
            //Resign First Responding before
            DismissKeyboard()
            
            collectionView(prizeCollectionView!, didDeselectItemAtIndexPath: NSIndexPath(forRow: selectedPrizeTypeIndex!, inSection: 0))
            
            let index = prizeCollectionView?.indexPathForItemAtPoint(sender.locationInView(prizeCollectionView))
            
            selectedPrizeTypeIndex = index!.row
            
            collectionView(prizeCollectionView!, didSelectItemAtIndexPath: NSIndexPath(forRow: selectedPrizeTypeIndex!, inSection: 0))
            
            
            let cell = prizeCollectionView?.cellForItemAtIndexPath(index!) as! testCollectionViewCell
            prizeType[selectedPrizeTypeIndex!].animate = true
            
            cell.isAnimating = true
            cell.rotate()
            
        default:
            
            break
        }
        
    }
    
    func prizeCellDoubleTapped(sender: UITapGestureRecognizer){
        print("doubleTap")
        
        //Resign First Responding before
        DismissKeyboard()
        
        collectionView(prizeCollectionView!, didDeselectItemAtIndexPath: NSIndexPath(forRow: selectedPrizeTypeIndex!, inSection: 0))
        
        let cell = getCellFromGesture(sender)
    
        prizeType[selectedPrizeTypeIndex!].animate = true
        
        cell.isAnimating = true
        cell.rotate()
    }
    
    func getCellFromGesture(gesture: AnyObject)->testCollectionViewCell{
        
        let index = prizeCollectionView?.indexPathForItemAtPoint(gesture.locationInView(prizeCollectionView))
        selectedPrizeTypeIndex = index!.row
        
        return prizeCollectionView?.cellForItemAtIndexPath(index!) as! testCollectionViewCell
        
    }
    
    
    func isSelectedCell(cell: testCollectionViewCell, selected: Bool){
        
        if selected{
            cell.prizeImage.layer.borderColor = UIColor(red: 0/255, green: 255/255, blue: 128/255, alpha: 1.0).CGColor
            cell.prizeImage.layer.borderWidth = 2.0
        }else
        {
            cell.prizeImage.layer.borderColor = UIColor(red: 255/255, green: 0/255, blue: 128/255, alpha: 1.0).CGColor
            cell.prizeImage.layer.borderWidth = 1.0
        }
        
        cell.prizeImage.layer.cornerRadius = 37.5
        cell.prizeImage.layer.masksToBounds = true
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if scrollView.tag == 1{
            collectionViewOffset = Float(scrollView.contentOffset.x)
            //self.tableView.reloadData()
        }
        
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == 1{
            collectionViewOffset = Float(scrollView.contentOffset.x)
            self.tableView.reloadData()
        }
    }

}
