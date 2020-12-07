//
//  day07.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-06.
//

import Foundation

func parseBagRule(_ text: String) -> (String, [Edge<String>]) {
    let parts = text.delete(["bags", "bag", "."]).splitOn("contain")
    let (node, children) = (parts[0], parts[1].splitOn(","))
    if (children.count == 1 && children.first == "no other") {
        return (node, [])
    } else {
        return (node, children
                    .map({ $0.take(1) })
                    .map({ Edge(from: node, to: $0.1.trim(), weight: Int($0.0)! ) }))
    }
}

func parseLuggageRulesToGraph(input: String) -> Graph<String> {
    var G: Graph<String> = Graph()
    for ruleText in input.splitOn(.newlines) {
        let (node, edges) = parseBagRule(ruleText)
        G.node(node)
        edges.forEach({ G.edge($0) })
    }
    return G;
}

func countInnerBags(origin: String, graph: Graph<String>) -> Int {
    guard let forwardEdges = graph.edges[origin] else {
        return 0
    }
    var inner = 0;
    for edge in forwardEdges {
        inner += edge.weight + edge.weight * countInnerBags(origin: edge.to, graph: graph)
    }
    return inner;
}

func day07() {
    day07test()
        
    let G = parseLuggageRulesToGraph(input: day7puzzleInput)
    let myBagColour = "shiny gold"

    let countAncestors = G.ancestors(origin: myBagColour).count
    assert(248 == countAncestors)
    print("Ancestors: \(countAncestors)")

    let innerBags = countInnerBags(origin: myBagColour, graph: G)
    assert(57281 == innerBags)
    print("Inner Bags: \(innerBags)")
}

func day07test() {
    testStringExtensions()
    testGraph()
    
    let G1 = parseLuggageRulesToGraph(input: """
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
""")
    assert(4 == G1.ancestors(origin: "shiny gold").count)
    
    let G2 = parseLuggageRulesToGraph(input: """
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
""")
    assert(126 == countInnerBags(origin: "shiny gold", graph: G2))
}
