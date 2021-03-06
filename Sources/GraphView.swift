//
//  GraphView.swift
//  GraphView
//
//  Created by Jaden Geller on 1/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import UIKit

public class GraphView: UIView {
    lazy private var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    lazy public var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panGestureRecognized:")
    
    var panAttachment: UIAttachmentBehavior? {
        willSet {
            if let panAttachment = panAttachment {
                animator.removeBehavior(panAttachment)
            }
        }
        didSet {
            if let panAttachment = panAttachment {
                animator.addBehavior(panAttachment)
            }
        }
    }
    
    func panGestureRecognized(recognizer: UIPanGestureRecognizer) {
        let point = recognizer.locationInView(self)
        switch recognizer.state {
        case .Began:
            if let view = hitTest(recognizer.locationInView(self), withEvent: nil), node = view.superview where graph.nodes.contains(view) {
                panAttachment = UIAttachmentBehavior(item: node, attachedToAnchor: point)
                panAttachment?.frequency = 5
            }
        case .Changed:
            panAttachment?.anchorPoint = point
        case .Ended:
            fallthrough
        case .Cancelled:
            panAttachment = nil
        default:
            break
        }
    }
    
    public var graph: Graph<UIView> {
        willSet {
            let removedNodes = graph.nodes.subtract(newValue.nodes)
            removedNodes.forEach { $0.superview!.removeFromSuperview() }
            animator.removeAllBehaviors()
        }
        didSet {
            // Add new nodes
            let addedNodes = graph.nodes.subtract(oldValue.nodes)
            addedNodes.forEach { self._addNode($0) }
            
            // Setup behaviors
            _setupBehaviors()
        }
    }
    
    public override func layoutSubviews() {
        graph.nodes.map{ $0.superview! }.forEach{ node in
            node.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        }
        for a in graph.nodes {
            let centerGravity = UIAttachmentBehavior(item: a.superview!, attachedToAnchor: self.center)
            centerGravity.length = 0
            centerGravity.damping = 1
            centerGravity.frequency = 0.5
            animator.addBehavior(centerGravity)
        }
        super.layoutSubviews()
    }
    
    private func _addNode(view: UIView) {
        precondition(!view.isDescendantOfView(self))
        let node = NodeView(view, withPadding: padding)
        addSubview(node)
    }
    
    private func _setupBehaviors() {
        animator.removeAllBehaviors()

        for (a, b) in graph.edges.map({ $0.tuple }) {
            let attachment = UIAttachmentBehavior(item: a.superview!, attachedToItem: b.superview!)
            attachment.length = 0
            attachment.damping = damping
            attachment.frequency = 1
            animator.addBehavior(attachment)
        }
        
        animator.addBehavior({
            let collision = UICollisionBehavior(items: Array(graph.nodes).map{ $0.superview! })
            collision.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsets(top: -padding, left: -padding, bottom: -padding, right: -padding))
            collision.collisionMode = .Everything
            return collision
        }())
        animator.addBehavior({
            let behavior = UIDynamicItemBehavior(items: Array(graph.nodes).map{ $0.superview! })
            behavior.allowsRotation = false
            behavior.elasticity = 1
            return behavior
        }())
        animator.addBehavior(DrawEdgeBehavior(graphView: self))

    }
    
    public init(graph: Graph<UIView>) {
        self.graph = graph
        super.init(frame: CGRect.zero)
        graph.nodes.forEach{ _addNode($0) }
        _setupBehaviors()
        addGestureRecognizer(panGestureRecognizer)
        backgroundColor = .whiteColor()
    }
    
    public var padding: CGFloat = 20 {
        didSet {
            _setupBehaviors()
        }
    }
    
    public var length: CGFloat = 200 {
        didSet {
            _setupBehaviors()
        }
    }
    
    public var damping: CGFloat = 1 {
        didSet {
            _setupBehaviors()
        }
    }
    
    public var frequency: CGFloat = 20 {
        didSet {
            _setupBehaviors()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding unsupoorted.")
    }
}

extension GraphView {
    func renderEdges() {
        setNeedsDisplay()
    }
    
    public override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextSetLineWidth(context, 5)
        for (a, b) in graph.edges.map({ $0.tuple }) {
            CGContextMoveToPoint(context, a.superview!.center.x, a.superview!.center.y)
            CGContextAddLineToPoint(context, b.superview!.center.x, b.superview!.center.y)
            CGContextMoveToPoint(context, b.superview!.center.x, b.superview!.center.y)
        }
        CGContextStrokePath(context)
    }
}
