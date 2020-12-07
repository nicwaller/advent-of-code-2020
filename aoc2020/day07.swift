//
//  day07.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-06.
//

import Foundation

struct BagRule {
    var bagColour: BagColour;
    var mayContain: Dictionary<BagColour, Int> = [:];
}

typealias Ruleset = Dictionary<BagColour, BagRule>

typealias BagColour = String

func parseBagRule(_ text: String) -> BagRule {
    let parts = text.components(separatedBy: "contain").map{ $0.trimmingCharacters(in: .whitespaces) }
    var rule = BagRule(bagColour: parts[0].replacingOccurrences(of: " bags", with: ""), mayContain: [:])
    let containsTxt: String = parts[1]
    let containsTxts: [String] = containsTxt.components(separatedBy: ",").compactMap{ $0.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "bags", with: "bag") .replacingOccurrences(of: " bag", with: "") }
    
    for cT in containsTxts {
        let s = String(cT)
        let key = String(s[s.index(s.startIndex, offsetBy: 2)...])
        rule.mayContain[key] = Int(String(cT.first!))
    }
    return rule
//    var rule = BagRule(bagColour: parts[0], );
}

// look up a bag, find what bags may contain it
var invertedIndex: Dictionary<BagColour, Set<BagColour>> = [:]

func bagsThatCanDeepContain(colour: BagColour, visited: inout Set<BagColour>) -> Set<BagColour> {
    print("Visiting \(colour)")

    if (visited.contains(colour)) {
        return Set();
    }

    guard let parents: Set<BagColour> = invertedIndex[colour] else {
        print(colour)
        return Set()
    }
    let result = parents
        .map{ bagsThatCanDeepContain(colour: $0, visited: &visited) }
        .reduce(parents) { $0.union($1) }
    visited.insert(colour)
    return result;
}

func day07() {
    day07test()
//    let rules = day7puzzleInput.components(separatedBy: .newlines).map{ parseBagRule($0) }
//    var ruleDict: Ruleset = [:]
    

    for ruleStr in day7puzzleInput.components(separatedBy: .newlines) {
        let rule = parseBagRule(ruleStr)
        for c in rule.mayContain.keys {
            if (!invertedIndex.keys.contains(c)) {
                invertedIndex[c] = Set()
            }
            invertedIndex[c]?.insert(rule.bagColour)
        }
    }
//    print(invertedIndex)
    let myBagColour = "shiny gold"
    var visited: Set<BagColour> = Set()
    let deepParents = bagsThatCanDeepContain(colour: myBagColour, visited: &visited)
    print(deepParents)
    print(deepParents.count)
    assert(248 == deepParents.count)
    
//    print(rules)

//    assert(987 == seats.max())
//    print("Highest: \(seats.max()!)")
//
//    let lastOfSeq = lastInSequence(seats.sorted())
//    assert(602 == lastOfSeq)
//    print("Missing: \(lastOfSeq + 1)")
}

func day07test() {
    assert(true == true)
}
