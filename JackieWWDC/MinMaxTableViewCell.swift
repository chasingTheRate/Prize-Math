//
//  MinMaxTableViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 3/19/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class MinMaxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var minIcon: UIView!
    @IBOutlet weak var maxIcon: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        minIcon.layer.masksToBounds = true
        minIcon.layer.cornerRadius = 5.0
        maxIcon.layer.masksToBounds = true
        maxIcon.layer.cornerRadius = 5.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
