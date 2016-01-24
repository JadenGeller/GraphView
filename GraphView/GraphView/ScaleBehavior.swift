//
//  ScaleBehavior.swift
//  GraphView
//
//  Created by Jaden Geller on 1/24/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import UIKit

class DrawEdgeBehavior: UIDynamicBehavior {
    init(graphView: GraphView) {
        super.init()
        self.action = { [weak graphView] in
            graphView?.renderEdges()
        }
    }
}