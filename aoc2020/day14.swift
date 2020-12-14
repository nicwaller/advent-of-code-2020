//
//  day14.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-13.
//

import Foundation

class Day14: AOC {
    
    typealias Directive = (String, Int, Int)
    
    static func parse(_ all: String) -> [Directive] {
        let lines = all.splitOn(.newlines)
        var dirs: [Directive] = []
        for line in lines {
            let parts = line.splitOn(" = ")
            if parts[0] == "mask" {
                dirs.append((parts[1], -1, -1))
            } else {
                let memAddrTxt = parts[0].replace("[", "").replace("]", "")
                let (_, addr) = memAddrTxt.take(3)
                dirs.append(("", Int(addr)!, Int(parts[1])!))
            }
        }
        return dirs
    }

    let input = parse(day14puzzleinput)
    let example = parse("""
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
""")
    
    func run(_ parts: [Directive]) -> Dictionary<Int, Int> {
        var memory: Dictionary<Int, Int> = [:]
        // var offMask = 0b111111111111111111111111111111111111
        var onMask = 0b000000000000000000000000000000000000
        var xorMasks: [Int] = [0]
        for inst in parts {
            if inst.0 == "" {
                let addr = inst.1
                let operand = inst.2
                if !memory.keys.contains(addr) {
                    memory[addr] = 0
                }
                for x in xorMasks {
                    let effectiveAddr = (addr | onMask) ^ x
                    memory[effectiveAddr] = operand
                }
            } else {
                let newMask: String = inst.0
//                offMask = Int(newMask.replace("X", "1"), radix: 2)!
                onMask = Int(newMask.replace("X", "0"), radix: 2)!
                xorMasks = compiledFloatMasks(newMask.replace("1", "0"))
            }
        }
        return memory
    }
    
//    func permute<X>(_ list: [X]) -> [(X, X)] {
//        if list.count == 0 {
//            return []
//        } else if list.count == 1 {
//            return [(list[0], list[0])]
//        } else {
//            let tail = list[1 ..< list.count]
//            let sub = permute(tail)
//
//        }
//    }
    
    // returns a set of bit masks to be XORed with the real memory address
    func floatMasks(mask: String) -> [String] {
//        var masks: [Int] = []
//        for (bitIndex, c) in mask.utf8.reversed().enumerated() {
//            if c == 88 /* X=88 */ {
//                masks.append(2 << (bitIndex-1))
//                print(c)
//            }
//        }
//        return masks
        if mask == "" {
//            print("impossible!")
            return [""]
        } else if mask.hasPrefix("X") {
            let (_, remainder) = mask.take(1)
            let tails = floatMasks(mask: remainder)
            return tails.map{ "0" + $0 } + tails.map{ "1" + $0 }
        } else {
            let (c, remainder) = mask.take(1)
            let tails = floatMasks(mask: remainder)
            return tails.map{ c + $0 }
        }
    }
    
    func compiledFloatMasks(_ mask: String) -> [Int] {
        return floatMasks(mask: mask).map{ Int($0, radix: 2)! }
    }

    func test() {
        print(example)
        let A = run(example)
        print(A.values)
//        assert(0 != A)
    }
    
    func part1() -> Void {
//        let A = run(input).values.reduce(0, +)
//        print("Part 1: \(A)")
//        assert(0 != A)
    }
    
    func part2() -> Void {
        let A = run(input).values.reduce(0, +)
        print("Part 2: \(A)")
//        assert(0 != A)
    }
}
