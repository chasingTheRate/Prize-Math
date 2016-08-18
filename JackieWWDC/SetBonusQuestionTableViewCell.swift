//
//  SetBonusQuestionTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 12/30/15.
//  Copyright © 2015 Eaton Productions. All rights reserved.
//

import UIKit

class SetBonusQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var labelSetBonusQuestion: UILabel!
    @IBOutlet weak var switchSetBonusQuestion: UISwitch!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let keySetBonusQuestion: String = "keySetBonusQuestion"
    let keySetPrize: String = "keySetPrize"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func SwitchValueChange(sender: UISwitch) {
        
        if sender.on
        {
            labelSetBonusQuestion.text = "ON"
        }else
        {
            labelSetBonusQuestion.text = "OFF"
        }
        
        if sender.tag == 0{
            self.userDefaults.setBool(sender.on, forKey: keySetBonusQuestion)
        }else
        {
            self.userDefaults.setBool(sender.on, forKey: keySetPrize)
        }

        
    }
    

}
