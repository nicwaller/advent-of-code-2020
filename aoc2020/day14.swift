//
//  day14.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-13.
//

import Foundation

class Day14: AOC {
    
    static func parse(_ all: String) -> [String] {
        let lines = all.splitOn(.newlines)
        return lines
    }

    let input = parse(day14puzzleinput)
    let example = parse("""
""")
    
    func fun1(_ parts: [String]) -> Int {
        return -1
    }

    func test() {
        let A = fun1(example)
        assert(0 != A)
    }
    
    func part1() -> Void {
        let A = fun1(input)
        print("Part 1: \(A)")
        assert(0 != A)
    }
    
    func part2() -> Void {
    }
}
