//
//  PrizeTableViewCell.swift
//  JackieWWDC
//
//  Created by Mark Eaton on 6/12/15.
//  Copyright (c) 2015 Eaton Productions. All rights reserved.
//

import UIKit

class PrizeTableViewCell: UITableViewCell {

    @IBOutlet weak var prizeTitle: UILabel!
    @IBOutlet weak var prizeDescription: UILabel!
    @IBOutlet weak var prizeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
