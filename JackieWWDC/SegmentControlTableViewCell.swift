//
//  SegmentControlTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 12/30/15.
//  Copyright © 2015 Eaton Productions. All rights reserved.
//

import UIKit

class SegmentControlTableViewCell: UITableViewCell {

    @IBOutlet weak var segmentControlBonusQuestionQty: UISegmentedControl!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let keyBonusQuestionQty: String = "keyBonusQuestionQty"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func segmentControlValueChange(sender: UISegmentedControl) {
        userDefaults.setObject(sender.selectedSegmentIndex, forKey: keyBonusQuestionQty)
    }
}
