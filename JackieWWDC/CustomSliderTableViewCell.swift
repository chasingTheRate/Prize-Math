//
//  CustomSliderTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 3/1/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class CustomSliderTableViewCell: UITableViewCell {

    @IBOutlet weak var minTextField: UITextField!
    @IBOutlet weak var maxTextField: UITextField!
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
