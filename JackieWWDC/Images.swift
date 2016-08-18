//
//  Images.swift
//  Prize Math
//
//  Created by Mark Eaton on 1/28/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import Foundation
import UIKit

class Images{
    
    func getImage(path: String)->UIImage? {
        
        let oldFullPath = documentsPathForFileName(path)
        
        if let oldImageData = NSData(contentsOfFile: oldFullPath)
        {
            return UIImage(data: oldImageData)
        }
        return nil
    }
    
    private func documentsPathForFileName(name: String) -> String {
        
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let path1 = paths.URLByAppendingPathComponent(name)
        let fullPath = path1.path!
        
        return fullPath
        
    }
}