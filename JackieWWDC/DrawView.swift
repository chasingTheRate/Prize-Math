//
//  DrawView.swift
//  Prize Math
//
//  Created by Mark Eaton on 12/21/15.
//  Copyright © 2015 Eaton Productions. All rights reserved.
//

import UIKit

class DrawView: UIView {

    var lines: [Line] = []
    var lastPoint: CGPoint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            lastPoint = touch.locationInView(self)
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            let newPoint = touch.locationInView(self)
            lines.append(Line(start:lastPoint, end:newPoint))
            lastPoint = newPoint
        }
        
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextBeginPath(context)
        for line in lines {
            CGContextMoveToPoint(context, line.start.x, line.start.y)
            CGContextAddLineToPoint(context, line.end.x, line.end.y)
        }
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetRGBStrokeColor(context, 1, 0, 128/255, 1.0)
        CGContextSetLineWidth(context, 5.0)
        CGContextStrokePath(context)
    }
}

class Line {
    var start: CGPoint
    var end:   CGPoint
    
    init(start _start: CGPoint, end _end: CGPoint) {
        start = _start
        end = _end
    }
}
