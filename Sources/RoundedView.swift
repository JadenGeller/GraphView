//
//  RoundedView.swift
//  GraphView
//
//  Created by Jaden Geller on 1/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import UIKit

public class RoundedView: UIView {
    public convenience init() {
        self.init(CGRect.zero)
    }
    
    public init(_ frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
    }
    
    public override func layoutSublayersOfLayer(layer: CALayer) {
        if layer == self.layer {
            layer.cornerRadius = min(bounds.width, bounds.height) / 2
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    public override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .Ellipse
    }
}