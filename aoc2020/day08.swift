//
//  day08.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-07.
//

import Foundation

enum Opcode: String {
    case acc = "acc"
    case jmp = "jmp"
    case nop = "nop"
}

struct Instruction {
    var opcode: Opcode;
    var operand: Int;
}

typealias Program = [Instruction]

struct ProgramResult: Equatable {
    var crashed: Bool;
    var acc: Int;
}

func decode(_ text: String) -> Program {
    return text
        .splitOn(.newlines)
        .map({
            let parts = $0.splitOn(" ");
            return Instruction(opcode: Opcode(rawValue: parts[0])!, operand: Int(parts[1])!)
        })
}

func execute(_ P: Program) -> ProgramResult {
    var sp = 0; // sp = stack pointer
    var acc = 0; // acc = accumulator
    
    // BitSet should be more compact (and faster?) than Set<Integer>
    var visited: BitSet = BitSet(size: P.count)
    while true {
        if (sp == P.count) { return ProgramResult(crashed: false, acc: acc) }
        if visited[sp] { return ProgramResult(crashed: true, acc: acc) }
        visited.set(sp)

        let ins: Instruction = P[sp]
        switch ins.opcode {
        case .acc:
            acc += ins.operand
            sp += 1
            break
        case .jmp:
            sp += ins.operand
            break
        case .nop:
            sp += 1
            break
        }
    }
}

func flip(_ opcode: Opcode) -> Opcode {
    switch opcode {
    case .jmp:
        return .nop
    case .nop:
        return .jmp
    default:
        return opcode
    }
}

func day08() {
    day08test()
    
    // Part 1
    var P = decode(day8puzzleInput)
    assert(ProgramResult(crashed: true, acc: 1331) == execute(P))
    print(execute(P))

    // Part 2
    for x in 0 ..< P.count {
        if P[x].opcode == .nop { continue }
        P[x].opcode = flip(P[x].opcode)
        let r = execute(P)
        P[x].opcode = flip(P[x].opcode)
        if (r.crashed == false) {
            print("Clean exit by editing line \(x): \(P[x])")
            assert(ProgramResult(crashed: false, acc: 1121) == r)
            print(r)
            return;
        }
    }
}

func day08test() {
    assert(ProgramResult(crashed: true, acc: 5) == execute(decode("""
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
""")))
    
    assert(ProgramResult(crashed: false, acc: 8) == execute(decode("""
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
nop -4
acc +6
""")))
}
