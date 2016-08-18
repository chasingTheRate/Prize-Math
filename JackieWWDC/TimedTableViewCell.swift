//
//  TimedTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 12/30/15.
//  Copyright © 2015 Eaton Productions. All rights reserved.
//

import UIKit

class TimedTableViewCell: UITableViewCell {

    let userDefaults = NSUserDefaults.standardUserDefaults()
    let keyTimeTextField: String = "keyTimeTextField"
    let keyTimeSwitch: String = "keyTimeSwitch"

    @IBOutlet weak var textFieldTimed: UITextField!
    @IBOutlet weak var switchTimed: UISwitch!
    @IBOutlet weak var labelTimed: UILabel!
    
    @IBAction func textFieldDidEndEditing(sender: UITextField) {
        if let value = Int(sender.text!){
            if value < 1  {
                sender.text = "1"
            }
        }else
        {
            sender.text = "1"
        }
        
        self.userDefaults.setValue(sender.text!, forKey: keyTimeTextField)
        self.userDefaults.synchronize()
    }
    
    @IBAction func SwitchValueChange(sender: UISwitch) {
        
        self.userDefaults.setBool(sender.on, forKey: keyTimeSwitch)
        self.userDefaults.synchronize()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
