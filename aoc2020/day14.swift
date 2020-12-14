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
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
""")
    
    func run(_ parts: [Directive]) -> Dictionary<Int, Int> {
        var memory: Dictionary<Int, Int> = [:]
        var offMask = 0b111111111111111111111111111111111111
        var onMask = 0b000000000000000000000000000000000000
        for inst in parts {
            if inst.0 == "" {
                let addr = inst.1
                let operand = inst.2
                if !memory.keys.contains(addr) {
                    memory[addr] = 0
                }
                memory[addr] = (operand | onMask) & offMask
            } else {
                let newMask: String = inst.0
                offMask = Int(newMask.replace("X", "1"), radix: 2)!
                onMask = Int(newMask.replace("X", "0"), radix: 2)!
            }
        }
        return memory
    }

    func test() {
        print(example)
        let A = run(example)
        print(A.values.reduce(0, +))
//        assert(0 != A)
    }
    
    func part1() -> Void {
        let A = run(input).values.reduce(0, +)
        print("Part 1: \(A)")
//        assert(0 != A)
    }
    
    func part2() -> Void {
    }
}
