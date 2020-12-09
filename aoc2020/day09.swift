//
//  day09.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-08.
//

import Foundation

func containsValid(list: [Int], range: Range<Int>, val: Int) -> Bool {
    for x in range.startIndex ..< list.count {
        for y in x ..< list.count {
            if list[x] + list[y] == val && list[x] != list[y] {
                return true;
            }
        }
    }
    return false;
}

func firstInvalid(list: [Int], preambleSize: Int = 25) -> Int {
    for x in preambleSize ..< list.count {
        if !containsValid(list: list, range: x-preambleSize ..< x, val: list[x]) {
            print(x)
            return list[x]
        }
    }
    return -1
}

func seqFinder(list: [Int], _ target: Int) -> [Int] {
    for x in 0 ..< list.count {
        for y in x ..< list.count {
            let sum = list[x ... y].reduce(0, +)
            if sum == target {
                return Array(list[x...y])
            } else if sum > target {
                break
            } else {
                continue
            }
        }
    }
    return [];
}

func day09() {
    day09test()
    
    // Part 1
    let cipherVals = day9puzzleInput.splitOn(.newlines).map({ Int($0)! })
    let fi = firstInvalid(list: cipherVals)
    assert(375054920 == fi)
    print(fi)
    
    let a2list = seqFinder(list: cipherVals, fi)
    let a2 = a2list.min()! + a2list.max()!
    assert(47412131 != a2)
    assert(54142584 == a2)
    print(a2)
}

func day09test() {
    var example: [Int] = Array(1 ... 25)
    assert(true == containsValid(list: example, range: 0 ..< 25, val: 26))
    assert(true == containsValid(list: example, range: 0 ..< 25, val: 49))
    assert(false == containsValid(list: example, range: 0 ..< 25, val: 100))
    assert(false == containsValid(list: example, range: 0 ..< 25, val: 50))
    let example2 = """
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
"""
    let e2 = example2.splitOn(.newlines).map({ Int($0)! })
    assert(127 == firstInvalid(list: e2, preambleSize: 5))
}
