//
//  CountingView.swift
//  Prize Math
//
//  Created by Mark Eaton on 3/2/16.
//  Copyright © 2016 Eaton Productions. All rights reserved.
//

import UIKit

class CountingView: UIView {
    
    var countViews: [UIView] = []
    
    var countItems: Int?
    var rows: Int = 1
    var columns: Int = 0
    var margin: CGFloat = 8.0
    var spacing: CGFloat = 0.0
    
    var primaryColor: UIColor = UIColor.whiteColor()
    var secondaryColor: UIColor = UIColor.whiteColor()
    
    var itemHeight: CGFloat = 0.0

    private var verticalAdjustment: CGFloat = 0.0
    private var horizontalAdjustment: CGFloat = 0.0

    func createCountingItems(){
        
        var xPos: CGFloat = 0.0
        var yPos: CGFloat = 0.0
        
        //Reset Rows and Columns
        rows = 1
        columns = 0
        
        //Define Spacing
        spacing = 10.0
    
        //Remove current views
        subviews.forEach({$0.removeFromSuperview()})
        
        //Calculate Count Item Height (item is square)
        itemHeight = getItemSize()

        
        if countItems == 0{
            return
        }
    
        calcAdjustments()
        
        var count = 0
        
        for i in 1...rows{
            
            if count == countItems!{
                break
            }
            
            if i == 1{
                yPos = margin + verticalAdjustment
            }else{
                yPos = yPos + itemHeight + spacing
            }
            
            for j in 1...columns{
                
                if count == countItems!{
                    break
                }
                
                if j == 1{
                    xPos = margin + horizontalAdjustment
                }else{
                    xPos = xPos + itemHeight + spacing
                }
                
                //Create new UIView
                let item = UIView(frame: CGRect(x: xPos, y: yPos, width: itemHeight, height: itemHeight))
                item.backgroundColor = self.primaryColor
                
                //Add tap Gesture
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
                item.addGestureRecognizer(tap)
                
                //Add to View
                self.addSubview(item)
                countViews.append(item)
                
                //Reset XPos if last item in Column
                
                if j == columns{
                    xPos = 0
                }
                
                count += 1
            }
        }
    }
    
    
    func getItemSize() -> CGFloat{
        
        var maxHeightSet = false
        var localItemWidth = CGFloat()
        var localItemHeight = CGFloat()
        var maxValue = CGFloat()
        
        //Loop until maxHeightSet = true
        while maxHeightSet == false{
    
            columns = Int(ceil(Double(countItems!)/Double(rows)))
        
            localItemWidth = (bounds.width - (2.0 * margin) - ((CGFloat(columns) - 1.0)*spacing))/CGFloat(columns)
            localItemHeight = (bounds.height - (2.0 * margin) - ((CGFloat(rows) - 1.0)*spacing))/CGFloat(rows)
            
            if localItemWidth > bounds.height{
                localItemWidth = (bounds.height - (2.0 * margin) - ((CGFloat(columns) - 1.0)*spacing))/CGFloat(columns)
            }
            
            if localItemHeight > bounds.width{
                localItemHeight = (bounds.width - (2.0 * margin) - ((CGFloat(rows) - 1.0)*spacing))/CGFloat(rows)
            }
            
            if (2.0 * margin) + (CGFloat(rows + 1) * localItemWidth) + (CGFloat(rows) * spacing) < bounds.height{
                rows += 1
                maxHeightSet = false
            }else{
                maxHeightSet = true
                maxValue = min(localItemWidth, localItemHeight)
            }
        }

        return maxValue
    }
    
    private func calcAdjustments(){
        
        //Horizontal Adjustment
        let totalSpacingWidth: CGFloat = 2.0 * margin + CGFloat(columns) * itemHeight + (CGFloat(columns)-1) * spacing
        horizontalAdjustment = (bounds.width/2) - (totalSpacingWidth/2)
        
        //Vertical Adjustment
        let totalSpacingHeight: CGFloat = 2.0 * margin + CGFloat(rows) * itemHeight + (CGFloat(rows)-1) * spacing
        verticalAdjustment = (bounds.height/2) - (totalSpacingHeight/2)
    }
    
    func tapped(sender: UITapGestureRecognizer!){
        if sender.view!.backgroundColor == primaryColor{
            sender.view!.backgroundColor = secondaryColor
        }else{
            sender.view!.backgroundColor = primaryColor
        }
    }
}
