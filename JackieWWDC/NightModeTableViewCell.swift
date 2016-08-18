//
//  NightModeTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/1/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class NightModeTableViewCell: UITableViewCell {

  
    @IBOutlet weak var nightModeSwitch: UISwitch!
    @IBOutlet weak var nightModeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
