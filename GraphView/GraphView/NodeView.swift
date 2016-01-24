//
//  NodeView.swift
//  GraphView
//
//  Created by Harrison Weinerman on 1/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import UIKit

public class NodeView: UIView {
    public var padding: CGFloat = 0 {
        didSet {
            _setupView()
            // update padding
            // may or may not have to call [updateIfNeeded]
        }
    }
    
    public var view: UIView {
        willSet {
            self.view.removeFromSuperview()
            // remove view from subview
        }
        didSet {
            _setupView()
            
            // add view as subview
            // add constraints such that
        }
    }
    
    private func _setupView() {
        
        
        addSubview(view)
        
        frame.size = CGSizeMake(view.frame.size.width + (2 * padding), view.frame.size.height + (2 * padding))

        view.frame.origin = CGPoint(x: view.frame.origin.x + padding, y: view.frame.origin.y + padding)
        
        self.translatesAutoresizingMaskIntoConstraints = false

    }
    
    public init(_ view: UIView) {
        self.view = view
        super.init(frame: CGRect.zero)
        _setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .Ellipse
    }
}
