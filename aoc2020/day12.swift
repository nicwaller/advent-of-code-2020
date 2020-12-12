//
//  day12.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-11.
//

import Foundation


class Day12: AOC {
    
    typealias Instruction = (String, Int)

    static func parse(_ all: String) -> [Instruction] {
        var insts: [Instruction] = [];
        for line in all.splitOn(.newlines) {
            let (char, num) = line.take(1)
            insts.append((char, Int(num)!))
        }
        return insts
    }

    let input = parse(day12puzzleInput)
    let example1 = parse("""
F10
N3
F7
R90
F11
""")
    
    func finalOffset(moves: [Instruction]) -> (Int, Int) {
        var x = 0
        var y = 0
        var bearing = 0.0 // start facing east
        for m in moves {
            switch m.0 {
            case "N":
                y += m.1
                break
            case "S":
                y -= m.1
                break
            case "E":
                x += m.1
                break
            case "W":
                x -= m.1
                break
            case "L":
                bearing += Double(m.1)
                break
            case "R":
                bearing -= Double(m.1)
                break
            case "F":
                let dx = m.1 * Int(cos(bearing / 180 * Double.pi))
                let dy = m.1 * Int(sin(bearing / 180 * Double.pi))
                x += dx
                y += dy
            default:
                print("what")
            }
            print(m)
            print((x,y, bearing))
        }
        return (x, y)
    }
    
    func test() {
        let d = finalOffset(moves: example1)
        let manhattan = abs(d.0) + abs(d.1)
        print(manhattan)
        assert(25 == manhattan)
    }
    
    func part1() -> Void {
        let d = finalOffset(moves: input)
        let manhattan = abs(d.0) + abs(d.1)
        assert(545 != manhattan)
        assert(1439 != manhattan)
        assert(445 == manhattan)
        print("Part 1: \(manhattan)")
    }
    
    func part2() -> Void {
//        let W = anneal(origin: input)
//        let c = countOccupied(W)
//        assert(2128 == c)
//        print(countOccupied(W))
    }
}
