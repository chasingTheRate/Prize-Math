//
//  Types.swift
//  Prize Math
//
//  Created by Mark Eaton on 4/5/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import Foundation
import UIKit

enum Types{
    
    case counting
    case basic
    case bonds
    case fractions
    
    func rawValue() -> Int{
        switch self{
        case counting:
            return 1
        case basic:
            return 0
        case bonds:
            return 2
        case fractions:
            return 3
        }
    }
    
    static func convertIntToType(sender: Int) -> Types?{
        switch sender{
        case 01:
            return .counting
        case 0:
            return .basic
        case 2:
            return .bonds
        case 3:
            return .fractions
        default:
            return nil
        }
    }
}

class Type: NSObject{
    
    var id: String?
    var numberOfSections = 0
    var numberOfRows: [Int] = []
    var rowHeights: [[CGFloat]] = []
    var headerText: [String] = []
    var tableViewCellIdentifiers: [String] = []
    var labelText: [[String]] = []
    
    //Row Heights
    var genericRowHeight: CGFloat = 44.0
    var collectionViewRowHeight: CGFloat = 120.0
    var minMaxCollectionViewRowHeight: CGFloat = 150
    
    //Header Heights
    var genericHeaderHeight: CGFloat = 40.0
    
    //Type Collection View Cell
    
    var type: Types = .counting

//    enum types{
//        
//        case counting
//        case basic
//        case bonds
//        case fractions
//        
//        func rawValue() -> Int{
//            switch self{
//            case counting:
//                return 0
//            case basic:
//                return 1
//            case bonds:
//                return 2
//            case fractions:
//                return 3
//            }
//        }
//        
//        func description() -> String{
//            switch self{
//            case .basic:
//                return "basic"
//            case .bonds:
//                return "bonds"
//            case .counting:
//                return "counting"
//            case .fractions:
//                return "fractions"
//            }
//        }
//        
//        func numberOfSections() -> Int{
//            switch self{
//            case .basic:
//                return 4
//            default:
//                return 3
//            }
//        }
    
//    }
    
//    func convertIntToType(sender: Int) -> type?{
//        switch sender{
//        case 0:
//            return .counting
//        case 1:
//            return .basic
//        case 2:
//            return .bonds
//        case 3:
//            return .fractions
//        default:
//            return nil
//        }
//    }

    
    override init(){
        
    }
    
}

class CountingType: Type{
    
    override init(){
        super.init()
        
        id = "Counting"
        numberOfSections = 3
        numberOfRows = [1,2,1]
        rowHeights = [[collectionViewRowHeight], [genericRowHeight, genericRowHeight], [collectionViewRowHeight]]
        
        headerText = ["TYPE", "MIN & MAX NUMBERS", "THEME"]
        tableViewCellIdentifiers = ["collectionViewInTableViewCell", "minMaxSingleTableViewCell", "collectionViewInTableViewCell"]
        labelText = [[], ["MIN", "MAX"], []]
        type = .counting
    }
}

class BasicType: Type{
    
    override init(){
        super.init()
        
        id = "Basic"
        numberOfSections = 4
        numberOfRows = [1,2,5,1]
        rowHeights = [[collectionViewRowHeight], [genericRowHeight, minMaxCollectionViewRowHeight], [genericRowHeight, genericRowHeight, genericRowHeight, genericRowHeight, genericRowHeight], [collectionViewRowHeight]]
    
        headerText = ["TYPE", "MIN & MAX NUMBERS", "OPTIONS", "THEME"]
        type = .basic
    }
}

class BondsType: Type{
    
    override init(){
        super.init()
        
        id = "Bonds"
        numberOfSections = 3
        numberOfRows = [1,2,1]
        rowHeights = [[collectionViewRowHeight], [genericRowHeight, genericRowHeight], [collectionViewRowHeight]]
        
        headerText = ["TYPE", "MIN & MAX NUMBERS", "THEME"]
        tableViewCellIdentifiers = ["collectionViewInTableViewCell", "minMaxSingleTableViewCell", "collectionViewInTableViewCell"]
        labelText = [[], ["Min", "Max"], []]
        type = .bonds
    }
}

class FractionsType: Type{
    
    override init(){
        super.init()
        
        id = "Fractions"
        numberOfSections = 3
        numberOfRows = [1,2,1]
        rowHeights = [[collectionViewRowHeight], [genericRowHeight, genericRowHeight], [collectionViewRowHeight]]
        
        headerText = ["TYPE", "MIN & MAX NUMBERS", "THEME"]
        tableViewCellIdentifiers = ["collectionViewInTableViewCell", "minMaxSingleTableViewCell", "collectionViewInTableViewCell"]
        labelText = [[], ["MIN", "MAX"], []]
        type = .fractions
    }
}