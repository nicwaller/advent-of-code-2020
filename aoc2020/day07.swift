//
//  day07.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-06.
//

import Foundation

struct BagRule {
    var node: BagColour;
    var edges: Dictionary<BagColour, Int> = [:];
}

typealias Ruleset = Dictionary<BagColour, BagRule>

typealias BagColour = String

func parseBagRule(_ text: String) -> BagRule {
    let parts = text.delete(["bags", "bag", "."]).splitOn("contain")
    let (node, children) = (parts[0], parts[1].splitOn(","))
    if (children.count == 1 && children.first == "no other") {
        return BagRule(node: node)
    } else {
        var rule = BagRule(node: node, edges: [:])
        for child in children {
            let (count, colour) = child.take(1)
            rule.edges[colour.trim()] = Int(count)
        }
        return rule
    }
}

var invertedIndex: Dictionary<BagColour, Set<BagColour>> = [:]

func bagsThatCanDeepContain(colour: BagColour, visited: inout Set<BagColour>) -> Set<BagColour> {
    if (visited.contains(colour)) {
        return Set();
    }

    guard let parents: Set<BagColour> = invertedIndex[colour] else {
        return Set()
    }
    let result = parents
        .map{ bagsThatCanDeepContain(colour: $0, visited: &visited) }
        .reduce(parents) { $0.union($1) }
    visited.insert(colour)
    return result;
}

var ruleDict: Ruleset = [:]

func containedBags(colour: BagColour) -> Int {
    if (ruleDict[colour]?.edges.count == 0) {
        return 0;
    } else {
        let inner = ruleDict[colour]!
        let innerCounts = inner.edges.map{ (1 + containedBags(colour: $0)) * $1 }
        return innerCounts.reduce(0, +)
    }
}

func day07() {
    day07test()
    
    for ruleStr in day7puzzleInput.components(separatedBy: .newlines) {
        let rule = parseBagRule(ruleStr)
        for c in rule.edges.keys {
            if (!invertedIndex.keys.contains(c)) {
                invertedIndex[c] = Set()
            }
            invertedIndex[c]?.insert(rule.node)
        }
        ruleDict[rule.node] = rule
        if rule.edges.keys.count == 0 {
            print(rule)
        }
    }
    let myBagColour = "shiny gold"
    var visited: Set<BagColour> = Set()
    let deepParents = bagsThatCanDeepContain(colour: myBagColour, visited: &visited)
    assert(248 == deepParents.count)
    print(deepParents.count)

    let deepChildren = containedBags(colour: myBagColour)
    assert(57281 == deepChildren)
    print(deepChildren)
}

func day07test() {
    assert("foo".trim("o") == "f")
    assert(true == true)
}

public extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func trim(_ chars: CharacterSet) -> String {
        return self.trimmingCharacters(in: chars)
    }
    func trim(_ chars: String) -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: chars))
    }
    func replace(_ needle: String, _ replacement: String) -> String {
        return self.replacingOccurrences(of: needle, with: replacement)
    }
    func splitOn(_ delimiter: String, trimWhitespace: Bool = true) -> [String] {
        if trimWhitespace {
            return self.components(separatedBy: delimiter).map{ $0.trim(.whitespaces) }
        } else {
            return self.components(separatedBy: delimiter)
        }
    }
    func delete(_ phrases: [String]) -> String {
        var converted = String(self)
        for needle in phrases {
            converted = converted.replace(needle, "")
        }
        return converted
    }
    func take(_ count: Int) -> (String, String) {
        let splitIndex: String.Index = self.index(self.startIndex, offsetBy: count)
        let taken = String(self[..<splitIndex])
        let remainder = String(self[splitIndex...])
        return (taken, remainder)
    }
}
