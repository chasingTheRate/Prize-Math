//
//  Complication.swift
//  Prize Math
//
//  Created by Mark Eaton on 2/10/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import Foundation

class Complication: NSObject, NSCoding {
    
    var title: String
    var imagePath: String
    var action: String?
    
    private let titleKey = "complicationTitle"
    private let actionKey = "complicationAction"
    private let imagePathKey = "complicationImagePath"
    
    init(title: String, action: String?, imagePath: String){
        self.title = title
        self.action = action
        self.imagePath = imagePath
    }
    
    required init (coder aDecoder: NSCoder) {
        
        self.title = aDecoder.decodeObjectForKey(titleKey) as! String
        self.action = aDecoder.decodeObjectForKey(actionKey) as? String
        self.imagePath = aDecoder.decodeObjectForKey(imagePathKey) as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey:titleKey)
        aCoder.encodeObject(action, forKey:actionKey)
        aCoder.encodeObject(imagePath, forKey:imagePathKey)
        
    }
    
}