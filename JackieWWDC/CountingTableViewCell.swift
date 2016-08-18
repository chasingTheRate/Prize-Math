//
//  CountingTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 3/2/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class CountingTableViewCell: UITableViewCell {

   
    @IBOutlet weak var countingView: CountingView!
    @IBOutlet weak var inputLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
