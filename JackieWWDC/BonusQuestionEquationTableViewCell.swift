//
//  BonusQuestionEquationTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 12/31/15.
//  Copyright © 2015 Eaton Productions. All rights reserved.
//

import UIKit

class BonusQuestionEquationTableViewCell: UITableViewCell {

    let userDefaults = NSUserDefaults.standardUserDefaults()
    let keyNumOfEquationsText: String = "keyNumOfEquationsText"

    @IBOutlet weak var textField1stNumber: UITextField!
    @IBOutlet weak var textFieldOperator: UITextField!
    @IBOutlet weak var textField2ndNumber: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
