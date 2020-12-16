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
        var seen: [Int] = Array(repeating: -1, count: 40000000)
//        for _ in 0 ... n {
//            seen.append(0)
//        }
        var lastWasNovel: Bool = true
        var distance: Int = 0
        var newNum = -1
        for (idx, num) in input.enumerated() {
            seen[num] = idx + 1
        }
        for turn in input.count+1 ... n {
            if lastWasNovel {
                newNum = 0
            } else {
                newNum = distance
            }

            lastWasNovel = seen[newNum] == -1
            distance = turn - seen[newNum]
            seen[newNum] = turn
        }
        return newNum
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
        print(nthn(n: 30000000, input: P))
    }
    
    func part2() -> Void {

    }
}
