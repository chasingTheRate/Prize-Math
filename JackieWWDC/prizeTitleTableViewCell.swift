//
//  prizeTitleTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 1/9/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class prizeTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldDescription: UITextField!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let keyPrizeTitleTextField: String = "keyPrizeTitleTextField"
    let keyPrizeDescriptionTextField: String = "keyPrizeDescriptionTextField"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.borderWidth = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func textFieldDidEndEditing(sender: UITextField) {
        
        switch sender.tag{
        
        case 0:
               self.userDefaults.setValue(sender.text!, forKey: keyPrizeTitleTextField)
        case 1:
               self.userDefaults.setValue(sender.text!, forKey: keyPrizeDescriptionTextField)
        default:
        break
    }
    
  
    }

}
