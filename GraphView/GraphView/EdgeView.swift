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
    internal var color: UIColor = .blackColor()
    internal var width: CGFloat = 1
    internal let (startView, controlView, endView) = (UIView(), UIView(), UIView())
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextSetLineWidth(context, width)
        CGContextMoveToPoint(context, 0, 0)
        CGContextAddQuadCurveToPoint(context, controlView.center.x, controlView.center.y, bounds.maxX, bounds.maxY)
        CGContextStrokePath(context)
    }
}
