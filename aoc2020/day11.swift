//
//  day11.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-10.
//

import Foundation

class Day11: AOC {
    typealias World = [[State]]
    
    enum State {
        case occupied
        case empty
        case floor
    }
    
    static func identify(_ c: String.Element) -> Optional<State> {
        switch c {
        case "L":
            return .empty
        case ".":
            return .floor
        case "#":
            return .occupied
        default:
            print(c)
            return nil
        }
    }
    
    static func parse(_ all: String) -> World {
        var lines: World = [];
        for line in all.splitOn(.newlines) {
            var row: [State] = []
            for char in line {
                row.append(identify(char)!)
            }
            lines.append(row)
        }
        return lines
    }

    let input = parse(day11puzzleInput)
    let example1 = parse("""
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
""")
    
    func next(_ W: World, x: Int, y: Int) -> State {
        if W[y][x] == .floor {
            return .floor
        }
        let x0 = max(x-1, 0)
        let x1 = min(x+1, W[0].count-1)
        let y0 = max(y-1, 0)
        let y1 = min(y+1, W.count-1)
        var nearbyEmpty = 0
        var nearbyOccupied = 0
        for ix in x0 ... x1 {
            for iy in y0 ... y1 {
                if (ix == x && iy == y) {
                    continue
                } else if W[iy][ix] == .occupied {
                    nearbyOccupied += 1
                } else if W[iy][ix] == .empty {
                    nearbyEmpty += 1
                }
            }
        }
        if nearbyOccupied == 0 {
            return .occupied
        } else if nearbyOccupied >= 4 {
            return .empty
        } else {
            return W[y][x]
        }
    }
    
    func oneEvolution(origin: World) -> World {
        var future = origin
        for (y, row) in future.enumerated() {
            for (x, _) in row.enumerated() {
                future[y][x] = next(origin, x: x, y: y)
            }
        }
        return future
    }

    func anneal(origin: World) -> World {
        var current = origin
        while true {
            let next = oneEvolution(origin: current)
            if next == current {
                break
            } else {
                current = next
            }
        }
        return current
    }
    
    func countOccupied(_ W: World) -> Int {
        var occ = 0
        for row in W {
            for cell in row {
                if cell == .occupied {
                    occ += 1
                }
            }
        }
        return occ
    }
    
    func test() {
        let x = example1
        print(render(x))
        let y = anneal(origin: x)
        print(render(y))
        let z = countOccupied(y)
        print(z)
    }
    
    func render(_ W: World) -> String {
        var buf: String = ""
        for y in 0 ..< W.count {
            var rowBuf: String = ""
            for state in W[y] {
                let char = (state == .floor) ? "." : (state == .empty ? "L" : "#")
                rowBuf += char
            }
            rowBuf += "\n"
            buf += rowBuf
        }
        return buf
    }
        
    
    func part1() -> Void {
        let W = anneal(origin: input)
        print(countOccupied(W))
//        let A = distribution(input)
//        assert((72, 0, 33) == A)
//        print("Part 1: \(A.0 * A.2) from distribution \(A)")
    }
    
    func part2() -> Void {
//        let P = permutations(input)
//        assert(129586085429248 == P)
//        print("Part 2: \(P)")
    }
}
