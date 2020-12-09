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
            return list[x]
        }
    }
    return -1
}

func seqFinder(list: [Int], _ target: Int) -> Optional<([Int], Range<Int>)> {
    // TODO: assert() that list is ordered ascending

    // Our goal is to calculate sums of subsequences
    // We can accelerate that by exploiting the commutative property of numeric sequences
    // If we pre-compute a sum list in O(n) time,
    // Then we can compute any subsequence sum in O(1) time.
    var sumlist: [Int] = []
    sumlist.append(0)
    for i in 0 ..< list.count {
        sumlist.append(list[i] + sumlist[i])
    }
    
    // Imagine a worm crawling along the number sequence
    // If the worm is too small, the head advances and eats a number
    // If the worm is too big, the tail needs to catch up to the head
    var head = 0
    var tail = 0
    
    while true {
        if head >= list.count {
            break
        }

        // Compute a subsequence sum in O(1) time. ;)
        let sum = sumlist[head + 1] - sumlist[tail]

        if sum == target {
            let seq = Array(list[tail ... head])
            return (seq, tail ..< head)
        } else if sum > target {
            tail += 1
            head = min(head, tail)
        } else if sum < target {
            head += 1
        }
    }
    return nil
}

func day09() {
    day09test()
    
    // Part 1
    let cipherVals = day9puzzleInput.splitOn(.newlines).map({ Int($0)! })
    let fi = firstInvalid(list: cipherVals)
    assert(375054920 == fi)
    print("Part 1: \(fi)")
    
    // Part 2
    guard let (a2list, a2range) = seqFinder(list: cipherVals, fi) else {
        print("failed to find sequence")
        return
    }
    let a2 = a2list.min()! + a2list.max()!
    assert(54142584 == a2)
    print("Part 2: \(a2) sum found at \(a2range)")
}

func day09test() {
    let example: [Int] = Array(1 ... 25)
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
""".splitOn(.newlines).map({ Int($0)! })
    assert(127 == firstInvalid(list: example2, preambleSize: 5))
    
    assert(([2, 3], 1 ..< 2 ) == seqFinder(list: [1, 2, 3, 4], 5) ?? ([], 0 ..< 0))
}
