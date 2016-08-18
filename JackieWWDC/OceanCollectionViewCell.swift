//
//  OceanCollectionViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 4/13/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class OceanCollectionViewCell: ThemeCollectionViewCell {
    

    @IBOutlet weak var oceanView: OceanView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        theme = Ocean()
    }
    
}
