//
//  day10.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-09.
//

import Foundation

class Day10: AOC {
    static func parse(_ all: String) -> [Int] {
        let sorted = all.splitOn(.newlines).map{ Int($0)! }.sorted()
        return [0] + sorted + [sorted.max()! + 3]
    }

    let input = parse(day10puzzleInput)
    let example1 = parse("""
16
10
15
5
1
11
7
19
6
12
4
""")
    let example2 = parse("""
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
""")
    
    func distribution(_ L: [Int]) -> (Int, Int, Int) {
        var d: [Int] = [0, 0, 0, 0]
        for x in 1 ..< L.count {
            d[L[x] - L[x-1]] += 1
        }
        return (d[1], d[2], d[3]);
    }
    
    var memo: Dictionary<Int, Int> = [:]
    func permutations(_ seq: [Int], index: Int = 0) -> Int {
        if index == 0 {
            memo.removeAll()
        } else if index == seq.count - 1 {
            return 1
        } else if memo.keys.contains(index) {
            return memo[index]!
        }

        var sum = 0;
        for i in index+1 ..< seq.count {
            if seq[i] - seq[index] <= 3 {
                sum += permutations(seq, index: i)
                memo[index] = sum
            } else {
                break
            }
        }
        return sum
    }
    
    func test() {
        assert((7, 0, 5) == distribution(example1))
        assert(8 == permutations(example1))
        assert(19208 == permutations(example2))
    }
    
    func part1() -> Void {
        let A = distribution(input)
        assert((72, 0, 33) == A)
        print("Part 1: \(A.0 * A.2) from distribution \(A)")
    }
    
    func part2() -> Void {
        let P = permutations(input)
        assert(129586085429248 == P)
        print("Part 2: \(P)")
    }
}
