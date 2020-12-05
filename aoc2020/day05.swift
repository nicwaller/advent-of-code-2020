//
//  day05.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-04.
//

import Foundation

func seatNumber(_ seatCode: String) -> Int {
    let binCode = seatCode
        .replacingOccurrences(of: "F", with: "0")
        .replacingOccurrences(of: "B", with: "1")
        .replacingOccurrences(of: "L", with: "0")
        .replacingOccurrences(of: "R", with: "1")
    return Int(binCode, radix: 2)!
}

// PERF: this can be made faster with a binary search
func lastInSequence(_ list: [Int]) -> Int {
    for i in 0 ..< list.count {
        if list[i + 1] - list[i] > 1 {
            return list[i]
        }
    }
    return -1
}

func day05() {
    day05test()
    let seats = day5puzzleInput.components(separatedBy: .newlines).map { seatNumber($0) }
    assert(987 == seats.max())
    print("Highest: \(seats.max()!)")

    let lastOfSeq = lastInSequence(seats.sorted())
    assert(602 == lastOfSeq)
    print("Missing: \(lastOfSeq + 1)")
}

func day05test() {
    assert(567 == seatNumber("BFFFBBFRRR"))
}
