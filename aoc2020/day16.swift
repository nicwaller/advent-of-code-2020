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
    
    func part2() -> Void {

    }
}
