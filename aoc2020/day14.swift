//
//  day14.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-13.
//

import Foundation

class Day14: AOC {
    
    enum Opcode {
        case load
            // v0 = address
            // v1 = scalar value
        case mask
            // v0 = onMask
            // v1 = float mask
    }
    
    struct Instruction {
        var op: Opcode
        var v0: Int
        var v1: Int
    }
        
    static func parse(_ all: String) -> [Instruction] {
        var dirs: [Instruction] = []
        for line in all.delete(["mem[", "]"]).splitOn(.newlines) {
            let parts = line.splitOn("=")
            if parts[0] == "mask" {
                let onMask = Int(parts[1].replace("X", "0"), radix: 2)!
                let floatMask = Int(parts[1].replace("1", "0").replace("X", "1"), radix: 2)!
                dirs.append(Instruction(op: .mask, v0: onMask, v1: floatMask))
            } else {
                dirs.append(Instruction(op: .load, v0: Int(parts[0])!, v1: Int(parts[1])!))
            }
        }
        return dirs
    }
    
    func run(_ instructions: [Instruction]) -> Dictionary<Int, Int> {
        var sparseMemory: Dictionary<Int, Int> = [:]
        var onMask = 0
        var xorMasks = [0]
        for instruction in instructions {
            switch instruction.op {
            case .load:
                let addr = instruction.v0 | onMask
                xorMasks.forEach{ sparseMemory[$0 ^ addr] = instruction.v1 }
                break
            case .mask:
                onMask = instruction.v0
                xorMasks = fast_polymask(instruction.v1)
                break
            }
        }
        return sparseMemory
    }

    func polymask(_ mask: Int) -> [Int] {
        // TODO: faster version
        // pre-allocate the entire buffer all at once
        // then fill in the bits with reducing stride lengths
        guard mask != 0 else { return [0] }
        if (mask & 1) == 1 {
            let subs = polymask(mask >> 1)
            return subs.map{ $0 << 1 } + subs.map{ $0 << 1 + 1 }
        } else if (mask & 0xF == 0) {
            // this branch only exists as a mild performance optimization
            return polymask(mask >> 4).map{ $0 << 4 }
        } else {
            return polymask(mask >> 1).map{ $0 << 1 }
        }
    }
    
    // currently this is actually slower, but maybe there is more room for optimization? -NW
    func fast_polymask(_ mask: Int) -> [Int] {
//        print(String(mask, radix: 2))
        // TODO: faster with malloc?
        let onBits = popcnt(mask)
        guard onBits != 0 else { return [0] }
        let count = (1 << onBits)
        var result: [Int] = []
        for _ in 0 ..< count {
            result.append(0)
        }
        result.reserveCapacity(count)
        var span = 1
        var steps = count >> 1
        for i in 0 ..< 36 {
            let selector = 1 << i
            let bit = mask & selector
            if bit > 0 {
                var pos = 0
                for _ in 0 ..< steps {
                    for _ in 0 ..< span {
                        result[pos] = result[pos] | selector
                        pos += 1
                    }
                    pos += span
                }
                steps = steps >> 1
                span = span << 1
            }
            // TODO: end the loop early, if possible?
        }
        return result
    }
    
    // this could be MUCH faster -NW
    // http://graphics.stanford.edu/~seander/bithacks.html
    func popcnt(_ n: Int) -> Int {
        if n == 0 {
            return 0
        } else {
            return n & 1 + popcnt(n >> 1)
        }
    }
    
    func test() -> Void {
        assert(0 == popcnt(0b0000))
        assert(1 == popcnt(0b0001))
        assert(1 == popcnt(0b0010))
        assert(2 == popcnt(0b0011))
        assert(3 == popcnt(0b0111))
        
        for x in 0...5 {
            print(polymask(x))
            print(fast_polymask(x))
        }
    }

    func part1() -> Void {
    }
    
    func part2() -> Void {
        // run your work
        var startParse: CFAbsoluteTime = 0.0
        var stopParse: CFAbsoluteTime = 0.0
        var startRun: CFAbsoluteTime = 0.0
        var stopRun: CFAbsoluteTime = 0.0
        
        // Part 1
        startParse = CFAbsoluteTimeGetCurrent()
        let P = Day14.parse(day14puzzleinput)
        stopParse = CFAbsoluteTimeGetCurrent()

        startRun = CFAbsoluteTimeGetCurrent()
        let A = run(P).values.reduce(0, +)
        stopRun = CFAbsoluteTimeGetCurrent()

        print("Part 2: \(A) (parse in \(round((stopParse - startParse) * 1000)) ms, run in \(round((stopRun - startRun) * 1000)) ms)")
        assert(A == 2741969047858)
    }
}
