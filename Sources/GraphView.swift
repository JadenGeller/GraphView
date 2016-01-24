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
            let removedEdges = graph.edges
            animator.removeAllBehaviors()
            graph.nodes.forEach{ $0.removeFromSuperview() }
        }
        didSet {
            _setupGraph()
        }
    }
    
    public override func layoutSubviews() {
        graph.nodes.map{ $0.superview! }.forEach{ node in
            node.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        }
        super.layoutSubviews()
    }
    
    private func _setupGraph() {
        graph.nodes.forEach{ view in
            let node = NodeView(view)
            node.padding = 20
             node.frame.origin = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5)
            addSubview(node)
        }
        for (a, b) in graph.edges {
            let attachment = UIAttachmentBehavior(item: a.superview!, attachedToItem: b.superview!)
            attachment.length = 0
            attachment.damping = damping
            attachment.frequency = 1
            animator.addBehavior(attachment)
        }
        animator.addBehavior({
            let collision = UICollisionBehavior(items: Array(graph.nodes).map{ $0.superview! })
            collision.translatesReferenceBoundsIntoBoundary = true
            collision.collisionMode = .Everything
            return collision
        }())
        animator.addBehavior({
            let behavior = UIDynamicItemBehavior(items: Array(graph.nodes).map{ $0.superview! })
            behavior.allowsRotation = false
            behavior.elasticity = 1
            return behavior
        }())

    }
    
    public init(graph: Graph<UIView>) {
        self.graph = graph
        super.init(frame: CGRect.zero)
        _setupGraph()
        addGestureRecognizer(panGestureRecognizer)
        backgroundColor = .whiteColor()
    }
    
    
    public var length: CGFloat = 200 {
        didSet {
            for behavior in animator.behaviors {
                if let attachement = behavior as? UIAttachmentBehavior {
                    attachement.length = length
                }
            }
        }
    }
    
    public var damping: CGFloat = 1 {
        didSet {
            for behavior in animator.behaviors {
                if let attachement = behavior as? UIAttachmentBehavior {
                    attachement.damping = damping
                }
            }
        }
    }
    
    public var frequency: CGFloat = 20 {
        didSet {
            for behavior in animator.behaviors {
                if let attachement = behavior as? UIAttachmentBehavior {
                    attachement.damping = damping
                }
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding unsupoorted.")
    }
}
