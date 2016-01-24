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
        }
    }
    
    public var view: UIView {
        willSet {
            self.view.removeFromSuperview()
        }
        didSet {
            _setupView()
        }
    }
    
    private func _setupView() {
        frame.size = CGSizeMake(view.frame.size.width + (2 * padding), view.frame.size.height + (2 * padding))
        frame.origin = view.frame.origin
        view.frame.origin = CGPoint(x: padding, y: padding)
        addSubview(view)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public init(_ view: UIView, withPadding padding: CGFloat) {
        self.view = view
        self.padding = padding
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
