//
//  day16.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-15.
//

import Foundation


class Day16: AOC {
    
    typealias Condition = (String, ClosedRange<Int>, ClosedRange<Int>)
    typealias Ticket = [Int]
        
    static func parse(_ all: String) -> ([Condition], Ticket, [Ticket]) {
        let sections = all.splitOn("\n\n")
        
        var conditions: [Condition] = []
        var myTicket: Ticket = []
        var tickets: [Ticket] = []
        
        let conditionTxt = sections[0].splitOn(.newlines)
        let myTxt = sections[1]
        let ticketLines = sections[2].delete(["nearby tickets:\n"]).splitOn(.newlines)
        
        for line in conditionTxt {
            let kv = line.splitOn(":")
            let key = kv[0]
            let rangeTxts = kv[1].splitOn("or")
            let ranges = rangeTxts.map{ $0.splitOn("-").map{ Int($0)! } }.map{ $0[0] ... $0[1] }
            conditions.append(( key, ranges[0], ranges[1] ))
        }
        
        myTicket = myTxt.delete(["your ticket:\n"]).splitOn(",").map{ Int($0)! }
        
        for line in ticketLines {
//            print(line)
            tickets.append(line.splitOn(",").map{ Int($0)! })
        }
        
        return (conditions, myTicket, tickets)
    }
    
    func basicOK(_ ticket: Ticket, conditions: [Condition]) -> (Bool, [Int]) {
        var rejects: [Int] = []
        search: for val in ticket {
            for c in conditions {
                if (c.1.contains(val) || c.2.contains(val)) {
                    // good enough!
                    continue search
                }
            }
            rejects.append(val)
        }
        return (rejects.count == 0, rejects)
    }
        
    func test() -> Void {
        let example = """
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
"""
        let P = Day16.parse(example)
        assert((true, []) == basicOK(P.2[0], conditions: P.0))
        assert((false, [4]) == basicOK(P.2[1], conditions: P.0))
//        print(P)
    }

    func part1() -> Void {
        let P = Day16.parse(day16puzzleinput)
        var errorRate = 0
        for ticket in P.2 {
            let (ok, rejects) = basicOK(ticket, conditions: P.0)
            if !ok {
                rejects.forEach{ errorRate += $0 }
            }
        }
        print(errorRate)
    }
    
    func testCond(cond: Condition, fieldIndex: Int, tickets: [Ticket]) -> Bool {
        search: for t in tickets {
            let val = t[fieldIndex]
            if cond.1.contains(val) || cond.2.contains(val) {
                continue search
            } else {
                // we found at least one ticket that doesn't satisfy this hypothesis
                return false
            }
        }
        return true
    }
    
    func part2() -> Void {
        let P = Day16.parse(day16puzzleinput)
        var validTickets: [Ticket] = []
        for ticket in P.2 {
            let (ok, _) = basicOK(ticket, conditions: P.0)
            if ok {
                validTickets.append(ticket)
            }
        }
        
        // fieldname -> possible indexes
        var maybeMappings: Dictionary<String, Set<Int>> = [:]
        for cond in P.0 {
            for i in 0 ..< P.0.count {
                if testCond(cond: cond, fieldIndex: i, tickets: validTickets) {
                    maybeMappings[cond.0, default: Set()].insert(i)
                } else {
//                    print("rejected hypothesis: \(cond.0) is maybe \(i)")
                }
            }
        }

        var confirmed: Dictionary<String, Int> = [:]
        while true {
            var knownKey: Optional<String> = nil
            var knownPlacement: Optional<Int> = nil
            for (offset, element) in maybeMappings.enumerated() {
                let (k, v) = element
//                print(v)
                if v.count == 1 {
                    knownKey = k
                    knownPlacement = v.first
//                    maybeMappings[k].remove(v.first!)
                }
            }
            if knownPlacement == nil {
//                print("could not resolve next")
                break
            }
            confirmed[knownKey!] = knownPlacement
            print((knownKey, knownPlacement))
            for (key, possibilities) in maybeMappings {
                var smaller: Set = possibilities
                smaller.remove(knownPlacement!)
                maybeMappings[key] = smaller
            }
//            maybeMappings[k] = Set()
        }
//        print(confirmed)
        let myTicket: Ticket = P.1
        let A = confirmed
            .filter{ $0.key.hasPrefix("departure") }
            .map{ myTicket[$0.value] }
            .reduce(1, *)
        print(A)
        assert(A > 1021440)
        // print(maybeMappings.values.map{ $0.count }.reduce(1, *)) // 2432902008176640000
    }
}
