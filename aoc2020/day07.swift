//
//  day07.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-06.
//

import Foundation

struct BagRule {
    var bagColour: BagColour;
    var mustContain: Dictionary<BagColour, Int> = [:];
}

typealias Ruleset = Dictionary<BagColour, BagRule>

typealias BagColour = String

func parseBagRule(_ text: String) -> BagRule {
    let parts = text.components(separatedBy: "contain").map{ $0.trimmingCharacters(in: .whitespaces) }
    var rule = BagRule(bagColour: parts[0].replacingOccurrences(of: " bags", with: ""), mustContain: [:])
    let containsTxt: String = parts[1]
    if (containsTxt == "no other bags.") {
        return rule;
    }
    let containsTxts: [String] = containsTxt.components(separatedBy: ",").compactMap{ $0.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "bags", with: "bag") .replacingOccurrences(of: " bag", with: "") }
    
    for cT in containsTxts {
        let s = String(cT)
        let key = String(s[s.index(s.startIndex, offsetBy: 2)...])
        rule.mustContain[key] = Int(String(cT.first!))
    }
    return rule
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
    if (ruleDict[colour]?.mustContain.count == 0) {
        return 0;
    } else {
        let inner = ruleDict[colour]!
        let innerCounts = inner.mustContain.map{ (1 + containedBags(colour: $0)) * $1 }
        return innerCounts.reduce(0, +)
    }
}

func day07() {
    day07test()
    
    for ruleStr in day7puzzleInput.components(separatedBy: .newlines) {
        let rule = parseBagRule(ruleStr)
        for c in rule.mustContain.keys {
            if (!invertedIndex.keys.contains(c)) {
                invertedIndex[c] = Set()
            }
            invertedIndex[c]?.insert(rule.bagColour)
        }
        ruleDict[rule.bagColour] = rule
        if rule.mustContain.keys.count == 0 {
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
    assert(true == true)
}
