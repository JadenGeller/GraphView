//
//  Edge.swift
//  GraphView
//
//  Created by Jaden Geller on 1/24/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct Edge<Node: Hashable> {
    public var start: Node
    public var end: Node
    
    public init(_ start: Node, _ end: Node) {
        self.start = start
        self.end = end
    }
}

extension Edge: Hashable {
    public var hashValue: Int {
        return start.hashValue ^ end.hashValue
    }
}

public func ==<Node: Hashable>(lhs: Edge<Node>, rhs: Edge<Node>) -> Bool {
    return lhs.start == lhs.end
}

extension Edge {
    public var tuple: (Node, Node) {
        return (start, end)
    }
}