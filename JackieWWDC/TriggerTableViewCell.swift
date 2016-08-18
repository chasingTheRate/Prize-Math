//
//  TriggerTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 12/30/15.
//  Copyright © 2015 Eaton Productions. All rights reserved.
//

import UIKit

class TriggerTableViewCell: UITableViewCell {

    let userDefaults = NSUserDefaults.standardUserDefaults()
    let keyTriggerText: String = "keyTriggerText"
    
    @IBOutlet weak var textFieldTrigger: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func textFieldDidEndEditing(sender: UITextField) {
        if let value = Int(sender.text!){
            if value < 1  {
                sender.text = "1"
            }
        }else
        {
            sender.text = "1"
        }
        
        self.userDefaults.setValue(sender.text!, forKey: keyTriggerText)
        self.userDefaults.synchronize()
    }
}
