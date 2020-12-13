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
        var shipx = 0
        var shipy = 0
        var x = 10
        var y = 1
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
                (x, y) = rotateLeft(x: x, y: y, degrees: m.1)
                break
            case "R":
                (x, y) = rotateRight(x: x, y: y, degrees: m.1)
                break
            case "F":
                let dx = m.1 * x
                let dy = m.1 * y
                shipx += dx
                shipy += dy
            default:
                print("what")
            }
//            print(m)
//            print("waypoint: \((x, y))")
//            print("ship: \((shipx, shipy))")
        }
        return (shipx, shipy)
    }

    func rotateLeft(x: Int, y: Int, degrees: Int) -> (Int, Int) {
        var nx = x
        var ny = y
        for _ in 1 ... (degrees / 90) {
            (nx, ny) = (-ny, nx)
        }
        print (nx, ny)
        return (nx, ny)
//        var r = (0, 0)
//        switch (degrees + 3599640) % 360 {
//        case 0:
//            r = (x, y)
//        case 90:
//            r = (y, x)
//        case 180:
//            r = (-x, -y)
//        case 270:
//            r = (y, -x)
//        default:
//            r = (0, 0)
//        }
////        print(x, y, degrees, r)
//        return r
    }
    
    func rotateRight(x: Int, y: Int, degrees: Int) -> (Int, Int) {
        var nx = x
        var ny = y
        for _ in 1 ... (degrees / 90) {
            (nx, ny) = (ny, -nx)
        }
        print (nx, ny)
        return (nx, ny)
    }
    
    func test() {
        assert((0, 1) == rotateLeft(x: 1, y: 0, degrees: 90))
        assert((-1, 0) == rotateLeft(x: 1, y: 0, degrees: 180))
        assert((0, -1) == rotateLeft(x: 1, y: 0, degrees: 270))
        assert((1, 0) == rotateLeft(x: 1, y: 0, degrees: 360))
//        assert((0, -1) == rotateLeft(x: 1, y: 0, degrees: -90))
//        assert((-1, 0) == rotateLeft(x: 1, y: 0, degrees: -180))
//        assert((0, 1) == rotateLeft(x: 1, y: 0, degrees: -270))

        let d = finalOffset(moves: example1)
        let manhattan = abs(d.0) + abs(d.1)
//        print(manhattan)
        assert(286 == manhattan)
    }
    
    func part1() -> Void {
    }
    
    func part2() -> Void {
        let d = finalOffset(moves: input)
        let manhattan = abs(d.0) + abs(d.1)
//        assert(545 != manhattan)
//        assert(1439 != manhattan)
//        assert(445 == manhattan)
        print("Part 2: \(manhattan)")
        assert(36449 != manhattan)
        assert(36423 != manhattan)
    }
}
