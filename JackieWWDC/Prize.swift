//
//  Prize.swift
//  JackieWWDC
//
//  Created by Mark Eaton on 6/12/15.
//  Copyright (c) 2015 Eaton Productions. All rights reserved.
//

import Foundation

class Prize: NSObject, NSCoding {
    
    var title: String
    var prizeDescription: String
    var imagePath: String
    var isSelected: Bool = false
    var isDefaultPrize: Bool = false
    var animate: Bool = false
    
    init(title: String, prizeDescription: String, imagePath: String){
        self.title = title
        self.prizeDescription = prizeDescription
        self.imagePath = imagePath
    }
    
    required init (coder aDecoder: NSCoder) {
        
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.prizeDescription = aDecoder.decodeObjectForKey("description") as! String
        self.imagePath = aDecoder.decodeObjectForKey("imagePath") as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey:"title")
        aCoder.encodeObject(prizeDescription, forKey:"description")
        aCoder.encodeObject(imagePath, forKey:"imagePath")
        
    }
    
    //override init(){}
}