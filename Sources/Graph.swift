//
//  Graph.swift
//  Edgy
//
//  Created by Jaden Geller on 1/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct Graph<Node: Hashable> {    
	private var edgeBacking = EdgeBacking<Node>()
	private(set) public var nodes = Set<Node>()
    
    public init<N: SequenceType, E: SequenceType where N.Generator.Element == Node, E.Generator.Element == (from: Node, to: Node)>(nodes: N, directedEdges: E) {
        for node in nodes { addNode(node) }
        for edge in directedEdges { addDirectedEdge(edge) }
    }
    
    public init<N: SequenceType, E: SequenceType where N.Generator.Element == Node, E.Generator.Element == (Node, Node)>(nodes: N, undirectedEdges: E) {
        for node in nodes { addNode(node) }
        for edge in undirectedEdges { addUndirectionalEdge(edge) }
    }
    
    public func adjacentNodes(node: Node) -> Set<Node> {
        return (edgeBacking.nodesReachableFromNode[node] ?? []).intersect(nodes)
    }
}

extension Graph {
    public init() {
        self.init(nodes: [])
    }
    
    public init<N: SequenceType where N.Generator.Element == Node>(nodes: N) {
        self.init(nodes: nodes, directedEdges: [])
    }
}

extension Graph {
    public var edges: Set<Edge<Node>> {
        return Set(nodes.flatMap { a in
            self.adjacentNodes(a).map { b in
                Edge(a, b)
            }
        })
    }
}

extension Graph {
	private mutating func requireUniqueBacking() {
		if !isUniquelyReferencedNonObjC(&edgeBacking) {
			edgeBacking = edgeBacking.copyByTrimmingIrrelevantNodes(relevantNodes: nodes)
		}
	}
	
	public mutating func addNode(node: Node) {
		requireUniqueBacking()
		
		nodes.insert(node)
		edgeBacking.nodesReachableFromNode[node] = []
	}
		
	public mutating func addUndirectionalEdge(lhs: Node, _ rhs: Node) {
		requireUniqueBacking()
		assert(nodes.contains(lhs) && nodes.contains(rhs), "An edge must be between nodes in the graph.")
		edgeBacking.nodesReachableFromNode[lhs]?.insert(rhs)
		edgeBacking.nodesReachableFromNode[rhs]?.insert(lhs)
	}
    
    public mutating func addDirectedEdge(from lhs: Node, to rhs: Node) {
        requireUniqueBacking()
        assert(nodes.contains(lhs) && nodes.contains(rhs), "An edge must be between nodes in the graph.")
        edgeBacking.nodesReachableFromNode[lhs]?.insert(rhs)
    }
}

