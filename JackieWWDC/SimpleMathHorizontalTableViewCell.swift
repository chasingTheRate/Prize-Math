//
//  SimpleMathHorizontalTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/8/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class SimpleMathHorizontalTableViewCell: UITableViewCell {

    @IBOutlet weak var equationLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var clearImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
