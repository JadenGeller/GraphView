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
    lazy private var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panGestureRecognized:")
    
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
            if let view = hitTest(recognizer.locationInView(self), withEvent: nil) where graph.nodes.contains(view) {
                panAttachment = UIAttachmentBehavior(item: view, attachedToAnchor: point)
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
            animator.removeAllBehaviors()
            graph.nodes.forEach{ $0.removeFromSuperview() }
        }
        didSet {
            _setupGraph()
        }
    }
    
    private func _setupGraph() {
        var z = 0
        graph.nodes.forEach{ view in
            self.addSubview(view)
            view.frame.origin = CGPoint(x: z, y: z)
            z += 50
            
            let push = UIPushBehavior(items: [view], mode: .Instantaneous)
            animator.addBehavior(push)
        }
        for (a, b) in graph.edges {
            let attachment = UIAttachmentBehavior(item: a, attachedToItem: b)
            attachment.length = 0
            attachment.damping = damping
            attachment.frequency = 1
            animator.addBehavior(attachment)
        }
        animator.addBehavior({
            let collision = UICollisionBehavior(items: Array(graph.nodes))
            collision.translatesReferenceBoundsIntoBoundary = true
            collision.collisionMode = .Everything
            return collision
        }())
        animator.addBehavior({
            let behavior = UIDynamicItemBehavior(items: Array(graph.nodes))
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
    
    public override func layoutSubviews() {
        // size changed
//        graph.nodes.forEach{ $0.center = center }
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
