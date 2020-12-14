//
//  day13.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-12.
//

import Foundation

class Day13: AOC {
    
    typealias Instruction = (String, Int)

    static func parse(_ all: String) -> (Int, [Optional<Int>]) {
        let lines = all.splitOn(.newlines)
        let earliestDeparture = Int(lines[0])!
        let routeTxt = lines[1]
        let routes = routeTxt.splitOn(",").map{ Int(String($0)) }
        return (earliestDeparture, routes)
    }

    let input = parse(day13puzzleinput)
    let examples = [
        parse("""
939
7,13,x,x,59,x,31,19
"""),
        parse("""
-1
17,x,13,19
"""),
        parse("""
939
67,7,59,61
"""),
        parse("""
939
67,x,7,59,61
"""),

    ]
    
    func nextDeparture(after: Int, routes: [Optional<Int>]) -> (Int, Int) {
        for i in after ... after + 100000 {
            for route in routes {
                if route == nil {
                    continue
                }
                if i % route! == 0 {
                    return (route!, i)
                }
            }
        }
        return (-1, -1)
    }
    
    func dumbGoldCoin(routes: [Optional<Int>]) -> Int {
        var t = 0
        search: while true {
            t += 1
            for (idx, route) in routes.enumerated() {
                if route == nil {
                    continue search
                }
                if (t + idx) % route! != 0 {
                    continue search
                }
            }
            break
        }
        return t
    }
    
    func smarterGoldCoin(routes: [Optional<Int>]) -> Int {
        let S = routes.enumerated().filter{ $0.1 != nil }.map{ ($0.0, $0.1!) }.sorted(by: { $0.1 > $1.1 })
        var start = -1
        let skip = S[0].1 * S[1].1
        for i in 0 ... S[0].1 * S[1].1 {
            if (i + S[0].0) % S[0].1 == 0 && (i + S[1].0) % S[1].1 == 0 {
                start = i
                break
            }
        }
        var t = start
        let locked = 1
        search: while true {
            t += skip
            if (t - start) % (skip * 10000000) == 0 {
                print(t)
            }
            for (idx, route) in S[locked ..< S.count] {
                let b = (t + idx) % route
                if b != 0 {
                    continue search
                }
            }
            break
        }
        return t
    }

    func test() {
        let x = nextDeparture(after: examples[0].0, routes: examples[0].1)
        assert((59, 944) == x)
        
        assert(3417 == smarterGoldCoin(routes: examples[1].1))
        assert(754018 == smarterGoldCoin(routes: examples[2].1))
        assert(779210 == smarterGoldCoin(routes: examples[3].1))
    }
    
    func part1() -> Void {
        let (route, departure) = nextDeparture(after: input.0, routes: input.1)
        let delay = departure - input.0
        let answer = delay * route
        print(answer)
        assert(3966 == answer)
    }
    
    func part2() -> Void {
        print(smarterGoldCoin(routes: input.1))
        let A = smarterGoldCoin(routes: input.1)
        print(A)
        assert(A == 800177252346225)
    }
}
