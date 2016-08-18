//
//  MaxNumberTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/1/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class MaxNumberTableViewCell: UITableViewCell {

    @IBOutlet weak var sliderMaxNumber1st: UISlider!
    @IBOutlet weak var sliderMaxNumber2nd: UISlider!

    @IBOutlet weak var textMaxNumber1st: UITextField!
    @IBOutlet weak var textMaxNumber2nd: UITextField!
    
    @IBOutlet weak var lockButton1st: UIButton!
    @IBOutlet weak var lockButton2nd: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
