//
//  GenericCollectionViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/9/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class GenericCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!

    func isSelectedCell(selected: Bool){
        
        if selected{
            self.cellImage.layer.borderColor = UIColor(red: 0/255, green: 255/255, blue: 128/255, alpha: 1.0).CGColor
            self.cellImage.layer.borderWidth = 2.0
        }else
        {
            self.cellImage.layer.borderColor = UIColor(red: 255/255, green: 0/255, blue: 128/255, alpha: 1.0).CGColor
            self.cellImage.layer.borderWidth = 1.0
        }
        
        self.cellImage.layer.cornerRadius = self.cellImage.layer.bounds.width/2
        self.cellImage.layer.masksToBounds = true
    }
    
}
