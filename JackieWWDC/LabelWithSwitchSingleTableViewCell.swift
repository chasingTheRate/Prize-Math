//
//  LabelWithSwitchSingleTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 3/12/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class LabelWithSwitchSingleTableViewCell: UITableViewCell {

    @IBOutlet weak var cellSwitch: UISwitch!
    @IBOutlet weak var cellLabel: UILabel!
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var iconLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.layer.cornerRadius = 5.0
        iconView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
