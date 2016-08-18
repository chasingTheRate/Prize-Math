//
//  GenericLabelAndTextTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/18/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class GenericLabelAndTextTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var iconLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.layer.cornerRadius = 5.0
        iconView.layer.masksToBounds = true
    }

}
