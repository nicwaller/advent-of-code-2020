//
//  graph.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-07.
//

import Foundation

struct Edge<T: Hashable>: Hashable {
    var from: T;
    var to: T;
    var weight = 1;
}

struct Graph<T: Hashable> {
    var nodes: Set<T> = Set();
    var edges: Dictionary<T, Set<Edge<T>>> = Dictionary();
    var invertedEdges: Dictionary<T, Set<Edge<T>>> = Dictionary();

    mutating func node(_ value: T) -> Void {
        self.nodes.insert(value)
    }
    
    mutating func edge(_ relation: Edge<T>) -> Void {
        if (relation.from == relation.to) {
            return; // TODO: throw error?
        }
        self.edges[relation.from, default: Set()].insert(relation)
        self.invertedEdges[relation.to, default: Set()].insert(relation)
    }
    mutating func edge(from: T, to: T, weight: Int = 1) -> Void {
        self.edge(Edge(from: from, to: to, weight: weight))
    }
    
    func ancestors(origin: T) -> Set<T> {
        var visited: Set<T> = Set()
        var ancestors: Set<T> = Set()
        var check: Set<T> = Set()
        check.insert(origin)
        while (check.count > 0) {
            let next = check.popFirst()!
            if (visited.contains(next)) {
                continue
            } else {
                visited.insert(next)
                guard let parents = invertedEdges[next] else {
                    continue
                }
                for parent in parents {
                    check.insert(parent.from)
                    ancestors.insert(parent.from)
                }
            }
        }
        return ancestors
    }
        
    // TODO: generators, or IteratorProtocol, or something cool
    // be flexible for breadth vs. depth-first traversal
    // avoid recursion to allow for much deeper traversals
    // maybe rename/alias to descendents() ?
    func traverse(origin: T) -> [Edge<T>] {
        guard let children = edges[origin] else {
            return []
        }
        let descendents = children.map{ traverse(origin: $0.to) }
        return children + descendents.reduce([], +)
    }
    
}

func testGraph() {
    var treeGraph: Graph<String> = Graph()
    treeGraph.edge(from: "grandfather", to: "father")
    treeGraph.edge(from: "father", to: "son")
    treeGraph.edge(from: "mother", to: "son")
    treeGraph.edge(from: "peer", to: "peer")
    let family = treeGraph.ancestors(origin: "son")
    assert(family == Set(["mother", "father", "grandfather"]))
    
    var digraph: Graph<String> = Graph()
    digraph.edge(from: "A", to: "B")
    digraph.edge(from: "A", to: "C")
    digraph.edge(from: "B", to: "D")
    digraph.edge(from: "C", to: "D")
    let prereqs = digraph.ancestors(origin: "D")
    assert(Set(["A", "B", "C"]) == prereqs)
}
