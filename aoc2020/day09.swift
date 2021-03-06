//
//  day09.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-08.
//

import Foundation

func firstInvalid(list: [Int], preambleSize: Int = 25) -> Optional<Int> {
    candidateSearch: for x in preambleSize ..< list.count {
        let q = list[x - preambleSize ..< x]
        for pick in q {
            if q.contains(list[x] - pick) {
                continue candidateSearch
            }
        }
        return list[x]
    }
    return nil
}

func seqFinder(list: [Int], _ target: Int) -> Optional<([Int], Range<Int>)> {
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
    
    while head < list.count {
        // Compute a subsequence sum in O(1) time. ;)
        let sum = sumlist[head + 1] - sumlist[tail]

        if sum == target {
            let seq = Array(list[tail ... head])
            return (seq, tail ..< head)
        } else if sum > target {
            tail += 1
        } else if sum < target {
            head += 1
        }
    }
    return nil
}

func day09() {
    day09test()
    
    // run your work
    var start: CFAbsoluteTime = 0.0
    var stop: CFAbsoluteTime = 0.0
    
    // Part 1
    let cipherVals = day9puzzleInput.splitOn(.newlines).map({ Int($0)! })
    start = CFAbsoluteTimeGetCurrent()
    let fi = firstInvalid(list: cipherVals)!
    stop = CFAbsoluteTimeGetCurrent()
    assert(375054920 == fi)
    print("Part 1: \(fi) (in \(round((stop - start) * 1000)) ms)")
    
    // Part 2
    start = CFAbsoluteTimeGetCurrent()
    guard let (a2list, a2range) = seqFinder(list: cipherVals, fi) else {
        print("failed to find sequence")
        return
    }
    stop = CFAbsoluteTimeGetCurrent()
    let a2 = a2list.min()! + a2list.max()!
    assert(54142584 == a2)
    print("Part 2: \(a2) sum found at \(a2range) (in \(round((stop - start) * 1000)) ms)")
}

func day09test() {
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
