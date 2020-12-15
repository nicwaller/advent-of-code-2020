//
//  day15.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-14.
//

import Foundation

class Day15: AOC {
        
    static func parse(_ all: String) -> [Int] {
        return all.splitOn(",").map{ Int($0)! }
    }
    
    func nthn(n: Int, input: [Int]) -> Int {
        var history: [Int] = input.reversed()
        var lastWasNovel: Bool = true
        for _ in input.count ..< n {
            var newNum = -1
            if lastWasNovel {
                newNum = 0
            } else {
                let diff = history[1...].firstIndex(of: history.first!)!
                newNum = diff
            }
            
            lastWasNovel = !history.contains(newNum)
            history.insert(newNum, at: 0)
        }
        return history.first!
    }
        
    func test() -> Void {
//        assert(0 == popcnt(0b0000))
        let P = Day15.parse("0,3,6")
        assert(0 == nthn(n: 4, input: P))
        assert(3 == nthn(n: 5, input: P))
        assert(3 == nthn(n: 6, input: P))
        assert(1 == nthn(n: 7, input: P))
//        let A = nthn(n: 4, input: P)
//        print(A)
    }

    func part1() -> Void {
        print("Part 1")
        let P = Day15.parse(day15puzzleinput)
        print(nthn(n: 2020, input: P))
    }
    
    func part2() -> Void {

    }
}
