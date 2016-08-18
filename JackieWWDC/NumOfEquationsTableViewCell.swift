//
//  NumOfEquationsTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 12/31/15.
//  Copyright © 2015 Eaton Productions. All rights reserved.
//

import UIKit

class NumOfEquationsTableViewCell: UITableViewCell {

    @IBOutlet weak var textFieldNumOfEquation: UITextField!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let keyNumOfEquationsText: String = "keyNumOfEquationsText"
    
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
        
        self.userDefaults.setValue(sender.text!, forKey: keyNumOfEquationsText)
        self.userDefaults.synchronize()
        
        print(userDefaults.stringForKey(keyNumOfEquationsText))
    }

}
