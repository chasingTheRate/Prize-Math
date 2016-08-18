//
//  CollectionViewInTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/9/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class CollectionViewInTableViewCell: UITableViewCell {

    @IBOutlet weak var genericCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
        
        genericCollectionView.delegate = dataSourceDelegate
        genericCollectionView.dataSource = dataSourceDelegate
        genericCollectionView.tag = row
        genericCollectionView.reloadData()
    }

}
