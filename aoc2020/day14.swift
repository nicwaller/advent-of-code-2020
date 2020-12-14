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
                xorMasks = polymask(instruction.v1)
                break
            }
        }
        return sparseMemory
    }

    func polymask(_ mask: Int) -> [Int] {
        guard mask != 0 else { return [0] }
        if (mask & 1) == 1 {
            let subs = polymask(mask >> 1)
            return subs.map{ $0 << 1 } + subs.map{ $0 << 1 + 1 }
        } else {
            return polymask(mask >> 1).map{ $0 << 1 }
        }
    }
    
    func test() -> Void {
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
