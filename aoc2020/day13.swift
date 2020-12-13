//
//  day13.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-12.
//

import Foundation

class Day13: AOC {
    
    typealias Instruction = (String, Int)

    static func parse(_ all: String) -> (Int, [Int]) {
        let lines = all.splitOn(.newlines)
        let earliestDeparture = Int(lines[0])!
        let routeTxt = lines[1]
        let routes = routeTxt.splitOn(",").compactMap{ Int(String($0)) }
        return (earliestDeparture, routes)
    }

    let input = parse(day13puzzleinput)
    let example1 = parse("""
939
7,13,x,x,59,x,31,19
""")
    
    func nextDeparture(after: Int, routes: [Int]) -> (Int, Int) {
        for i in after ... after + 100000 {
            for route in routes {
                if i % route == 0 {
                    return (route, i)
                }
            }
        }
        return (-1, -1)
    }

    func test() {
        let x = nextDeparture(after: example1.0, routes: example1.1)
        assert((59, 944) == x)
    }
    
    func part1() -> Void {
        let (route, departure) = nextDeparture(after: input.0, routes: input.1)
        let delay = departure - input.0
        let answer = delay * route
        print(answer)
        assert(3966 == answer)
    }
    
    func part2() -> Void {
    }
}
