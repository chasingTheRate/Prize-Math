//
//  PrizeTableViewController.swift
//  JackieWWDC
//
//  Created by Mark Eaton on 6/10/15.
//  Copyright (c) 2015 Eaton Productions. All rights reserved.
//

import UIKit

class PrizeTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var parentalSettings: UIBarButtonItem!
    
    var prizeArray = [Prize]()
    var images = Images()
    var colors = Colors()
    var nightMode: Bool = false
    var passCodePresented = false
    var passcodeIsOn = false
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var colorSelection: Int = 0
    
    //MARK: IB Functions
    
    @IBAction func showParentalControl(sender: UIBarButtonItem) {
        
        if passcodeIsOn{
            
            let storyBoard1 = self.storyboard
            let passcodeVC = storyBoard1!.instantiateViewControllerWithIdentifier("passcodeVC") as! PasscodeViewController
            
            passcodeVC.setPasscode = false
            self.presentViewController(passcodeVC, animated: true, completion: nil)
            
        }else{
            segueToParentalControl()
        }
        
    }
    
    
    //MARK: View Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        getUserSettings()
        updateUI()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)
        saveUserSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    func updateUI(){
        
        if nightMode{
            tableView.backgroundColor = colors.nightModeSection
        }else{
            tableView.backgroundColor = colors.nightModeSectionOff
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //print(prizeArray.count)
        return prizeArray.count
        
    }

    private struct Storyboard {
        static let CellReuseIdentifier = "PrizeCell"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> PrizeTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! PrizeTableViewCell

        cell.prizeTitle.text = prizeArray[indexPath.row].title
        cell.prizeDescription.text = prizeArray[indexPath.row].prizeDescription
        
        if let image = images.getImage(prizeArray[indexPath.row].imagePath){
            cell.prizeImage.image = image
        }else{
            cell.prizeImage.image = UIImage(named: "prizeCollectionViewCellImageLarge.png")
        }
        
        cell.prizeImage.layer.cornerRadius = 25
        cell.prizeImage.layer.masksToBounds = true
        cell.prizeImage.layer.borderColor = colors.primaryColor[colorSelection]?.CGColor
        cell.prizeImage.layer.borderWidth = 1.0
        
        //Disable User Selection
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        nightMode(cell.contentView)
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            prizeArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let claimButton = UITableViewRowAction(style: .Default, title: "Claim", handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commitEditingStyle: .Delete,
                forRowAtIndexPath: indexPath
            )
            
            return
        })
        
        claimButton.backgroundColor = colors.primaryColor[colorSelection]
        
        return [claimButton]
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
        
        return 1.0
    }
    
    //MARK: Segues
    
    func segueToParentalControl(){
        
        self.performSegueWithIdentifier("showParentalControl", sender: nil)
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
    
    
    //MARK: User Defaults
    
    let keyColorSelection: String = "keyColorSelection"
    
    func getUserSettings(){
        
        //Color Selection
        if let value = userDefaults.stringForKey(keyColorSelection){
            colorSelection = Int(value)!
        }
        
        //Prizes already won
        let prizeData = userDefaults.objectForKey(UserDefaults.key.prizesWon.rawValue) as? NSData
        
        if let prizeData = prizeData {
            prizeArray = (NSKeyedUnarchiver.unarchiveObjectWithData(prizeData) as? [Prize])!
        }
        
        print(prizeArray.count)
        
        //Passcode on?
        
        passcodeIsOn = userDefaults.boolForKey(UserDefaults.key.passcodeOn.rawValue)
        
    }
    
    func saveUserSettings(){
        
        let prizeData = NSKeyedArchiver.archivedDataWithRootObject(prizeArray)
        userDefaults.setObject(prizeData, forKey: "prizes")
    }

}
