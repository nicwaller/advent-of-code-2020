//
//  day17.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-17.
//

import Foundation

class Day17: AOC {
            
    static func parse(_ all: String) -> [String] {
        return all.splitOn(.newlines)
    }
            
    func test() -> Void {
        let example = """
test
"""
        let P = Day17.parse(example)
        print(P)
        print("tests OK")
    }

    func part1() -> Void {
        let P = Day17.parse(day17puzzleinput)
        print(P)
        let A = -1
        print("Part 1: \(A)")
    }
    
    func part2() -> Void {
        let A = -1
        print("Part 2: \(A)")
    }
}
