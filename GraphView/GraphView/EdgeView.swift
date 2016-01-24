//
//  EdgeView.swift
//  GraphView
//
//  Created by Jaden Geller on 1/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import UIKit

enum Sign {
    case Positive
    case Negative
}

internal class EdgeView: UIView {
    var slope: Sign = .Positive
    var color: UIColor = .blackColor()
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextMoveToPoint(context, 0, 0)
        CGContextAddLineToPoint(context, bounds.maxX, bounds.maxY)
        CGContextStrokePath(context)
    }
}
