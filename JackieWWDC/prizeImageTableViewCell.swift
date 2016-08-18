//
//  prizeImageTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 1/9/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class prizeImageTableViewCell: UITableViewCell {

    @IBOutlet weak var prizeImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        prizeImage.layer.borderWidth = 2.0
        prizeImage.layer.borderColor = UIColor(red: 255/255, green: 0/255, blue: 128/255, alpha: 1.0).CGColor
        prizeImage.layer.cornerRadius = prizeImage.layer.bounds.width/2
        prizeImage.layer.masksToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
