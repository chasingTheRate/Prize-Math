//
//  PrizeTypeTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 1/9/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class PrizeTypeTableViewCell: UITableViewCell {
   
    
    
    @IBOutlet weak var prizeTypeContentView: UIView!
    @IBOutlet weak var testCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        testCollectionView.showsHorizontalScrollIndicator = false
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
    
        testCollectionView.delegate = dataSourceDelegate
        testCollectionView.dataSource = dataSourceDelegate
        testCollectionView.tag = row
        testCollectionView.reloadData()
        
        
    }
}

