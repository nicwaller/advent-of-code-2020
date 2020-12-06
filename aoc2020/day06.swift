//
//  day06.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-05.
//

import Foundation

func aToBitmap(_ answers: String) -> UInt32 {
    let buf: [UInt8] = Array(answers.utf8)
    var bmap: UInt32 = 0
    for char in buf {
        bmap |= 1 << (char & 0b00011111)
    }
    return bmap >> 1
}

// "rank" is shorthand for "number of bits set to true"
// also known as the 'Hamming Weight', 'popcount' or 'sideways addition'
@inlinable
@inline(__always)
func popcount(_ bmap: UInt32) -> UInt32 {
    // If I was programming in C for x86 architecture I could do this in a single instruction:
    // return __builtin_popcount(bmap)
    // Instead, I use a semi-optimized version by Kernighan
    // https://graphics.stanford.edu/~seander/bithacks.html#CountBitsSetKernighan
    var v: UInt32 = bmap;
    var c: UInt32 = 0;
    while (v != 0) {
        v &= v - 1; // clear the least significant bit set
        c += 1;
    }
    return c;
}

func day06() {
    day06test()
    let groups: [[UInt32]] = day6puzzleInput.components(separatedBy: "\n\n")
        .map{ $0.components(separatedBy: "\n").map{ aToBitmap($0) } }
    print(groups.map{ $0.reduce(0) {$0 | $1} }.map{ popcount($0) }.reduce(0, +))
    print(groups.map{ $0.reduce(0xFFFFFFFF) { $0 & $1 } }.map{ popcount($0) }.reduce(0, +))
}

func day06test() {
    assert(1 == aToBitmap("a"))
    assert(2 == aToBitmap("B"))
    assert(4 == aToBitmap("c"))
    assert(7 == aToBitmap("abc"))
    
    assert(0 == popcount(0b00000000))
    assert(2 == popcount(0b10000001))
    assert(8 == popcount(0b11111111))
    assert(32 == popcount(0b11111111111111111111111111111111))
}
