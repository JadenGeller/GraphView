//
//  EdgeBacking.swift
//  Edgy
//
//  Created by Jaden Geller on 1/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

internal class EdgeBacking<Node: Hashable> {
    var nodesReachableFromNode = Dictionary<Node, Set<Node>>()
    
    init(nodesReachableFromNode: Dictionary<Node, Set<Node>> = [:]) {
        self.nodesReachableFromNode = nodesReachableFromNode
    }
    
    func copyByTrimmingIrrelevantNodes(relevantNodes relevantNodes: Set<Node>) -> EdgeBacking {
        var copy = Dictionary<Node, Set<Node>>()
        for (key, value) in nodesReachableFromNode {
            if relevantNodes.contains(key) {
                copy[key] = value.intersect(relevantNodes)
            }
        }
        return EdgeBacking(nodesReachableFromNode: copy)
    }
}