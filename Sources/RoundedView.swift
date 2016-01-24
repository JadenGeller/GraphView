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
    }
    
    public override func layoutSublayersOfLayer(layer: CALayer) {
        if layer == self.layer {
            layer.cornerRadius = min(bounds.width, bounds.height) / 2
//            let padding = NodeView(CGRectInset(self.frame, -20, -20))
//            self.addSubview(padding)
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}