//
//  ParentControllerTableViewController2.swift
//  Prize Math
//
//  Created by Mark Eaton on 12/29/15.
//  Copyright © 2015 Eaton Productions. All rights reserved.
//

import UIKit

class ParentControllerTableViewController2: UITableViewController {

    var colorSelection: Int = 0
    var colors = Colors()
    var nightMode: Bool = false
    var passcodeSwitch: UISwitch?
    var passcodeIsOn = false
    
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        getUserDefaults()
        
        if nightMode{
            tableView.backgroundColor = colors.nightModeSection
        }else{
            tableView.backgroundColor = colors.nightModeSectionOff
        }
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)
        
        saveUserDefaults()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section{
        
            case 0:
                return 2
            default:
                return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section
        {
        case 0:
            
            switch indexPath.row
            {
            case 0:
                self.performSegueWithIdentifier("sequeShowSetBonusQuestion", sender: self)
            case 1:
                self.performSegueWithIdentifier("segueShowSetPrize", sender: self)
            default:
                break
            }
        default:
            break
        }
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section
        {
            
        case 0:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("setQuestion", forIndexPath: indexPath) as! ParentControlSetQuestionTableViewCell
            
            switch indexPath.row
            {
            case 0:
                cell.setLabel.text = "Set Bonus Question"
                if userDefaults.boolForKey(UserDefaults.key.setBonusQuestion.rawValue)
                {
                    cell.detailTextLabel?.text = "On"
                }else
                {
                    cell.detailTextLabel?.text = "Off"
                }
            case 1:
                cell.setLabel.text = "Set Prize"
                if userDefaults.boolForKey(keySetPrize)
                {
                    cell.detailTextLabel?.text = "On"
                }else
                {
                    cell.detailTextLabel?.text = "Off"
                }
            default:
                break
            }

            nightMode(cell)
            
            return cell
        
        case 1:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("passwordCell", forIndexPath: indexPath) as! ParentControlPasswordTableViewCell
            
            passcodeSwitch = cell.passcodeSwitch
            passcodeSwitch!.on = passcodeIsOn
            passcodeSwitch?.addTarget(self, action: #selector(passcodeValueChanged), forControlEvents: .ValueChanged)
            cell.selectionStyle = .None
            
            nightMode(cell)
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("setQuestion", forIndexPath: indexPath)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! HeaderCell
        cell.headerLabel.text = ""
        cell.backgroundColor = UIColor.clearColor()
        
        if nightMode{
            cell.headerView.backgroundColor = colors.nightModeSection
            cell.headerLabel.textColor =  colors.nightModeSectionText
        }else{
            cell.headerView.backgroundColor = colors.nightModeSectionOff
            cell.headerLabel.textColor =  colors.nightModeSectionTextOff
        }
        
        return cell
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
    

    func passcodeValueChanged(sender: UISwitch){
        
        if sender.on{
            passcodeIsOn = true
            
            if passcodeIsOn{
                
                let storyBoard1 = self.storyboard
                let passcodeVC = storyBoard1!.instantiateViewControllerWithIdentifier("passcodeVC") as! PasscodeViewController
                
                passcodeVC.setPasscode = true
                self.presentViewController(passcodeVC, animated: true, completion: nil)
                
            }
            
        }else{
            passcodeIsOn = false
        }
    }
    
    func nightMode(sender: UITableViewCell){
        
        if nightMode{
            sender.contentView.superview!.backgroundColor = colors.nightModeViewCell
            sender.contentView.layer.borderColor = colors.nightModeViewCell.CGColor
            sender.detailTextLabel?.textColor = colors.nightModeDetailText
            
        }else{
            sender.contentView.superview!.backgroundColor = colors.nightModeViewCellOff
            sender.contentView.layer.borderColor = colors.nightModeViewCellOff.CGColor
            sender.detailTextLabel?.textColor = colors.nightModeDetailTextOff
        }
    }
    
    //MARK: User Defaults
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let keySetPrize: String = "keySetPrize"
    

    
    func getUserDefaults(){
        
        //Color Selection
        
        if let value = userDefaults.stringForKey(UserDefaults.key.colorSelection.rawValue){
            colorSelection = Int(value)!
        }
        
        //Passcode On?
        
        passcodeIsOn = userDefaults.boolForKey(UserDefaults.key.passcodeOn.rawValue)
    }


    func saveUserDefaults(){
        
        //Passcode On?
        
        userDefaults.setBool(passcodeIsOn, forKey: UserDefaults.key.passcodeOn.rawValue)
    }

}
