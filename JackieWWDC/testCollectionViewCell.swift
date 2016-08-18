//
//  testCollectionViewCell.swift
//  Prize Math
//
//  Created by Mark Eaton on 1/9/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class testCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var prizeImage: UIImageView!
    
    var isAnimating: Bool = false
    


    func rotate(){
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = Float(2*M_PI)
        rotationAnimation.duration = 1.0
        rotationAnimation.cumulative = true
        rotationAnimation.repeatCount = Float.infinity
        
        self.prizeImage.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopRotate(){
        self.prizeImage.layer.removeAllAnimations()
        self.prizeImage.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1.0)
    }

}
