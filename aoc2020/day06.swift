//
//  day06.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-05.
//

import Foundation

func aToBitmap(_ answers: String) -> UInt32 {
    var bmap: UInt32 = 0
    Array(answers.utf8).forEach{ bmap |= 1 << ($0 & 0b00011111) }
    return bmap >> 1;
}

func popcount(_ bmap: UInt32) -> UInt32 {
    var v: UInt32 = bmap;
    var c: UInt32 = 0;
    while (v != 0) { v &= v - 1; c += 1 }
    return c;
}

func day06() {
    let groups = day6puzzleInput.components(separatedBy: "\n\n")
        .map{ $0.components(separatedBy: "\n").map{ aToBitmap($0) } }
    print(groups.map{ $0.reduce(0) {$0 | $1} }.map{ popcount($0) }.reduce(0, +))
    print(groups.map{ $0.reduce(0xFFFFFFFF) { $0 & $1 } }.map{ popcount($0) }.reduce(0, +))
}
