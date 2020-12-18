//
//  day18.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-18.
//

import Foundation

class Day18: AOC {
    
    static func parse(_ all: String) -> [String] {
        return all.splitOn(.newlines)
    }
            
    func test() -> Void {
        let example = """
.#.
..#
###
"""
        var P = Day18.parse(example)
        print(P.count)
        print("tests OK")
    }

    func part1() -> Void {
        var P = Day18.parse(day18puzzleinput)
        print(P)


        let A = P.count
        print("Part 1: \(A)")
//        assert(A == 291)
    }
    
    func part2() -> Void {
        var P = Day18.parse(day18puzzleinput)
        print(P)


        let A = P.count
        print("Part 2: \(A)")
//        assert(A == 291)
    }
}
