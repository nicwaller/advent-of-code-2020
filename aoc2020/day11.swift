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
    
    func visibleOccupied(_ W: World, x: Int, y: Int) -> Int {
//        let x0 = max(x-1, 0)
//        let x1 = min(x+1, W[0].count-1)
//        let y0 = max(y-1, 0)
//        let y1 = min(y+1, W.count-1)
        var nearbyEmpty = 0
        var nearbyOccupied = 0
        for dx in -1 ... 1 {
            for dy in -1 ... 1 {
                if (dx == 0 && dy == 0) {
                    continue
                }
                var ix = x
                var iy = y
                var visible: State = .floor
                while visible == .floor {
                    ix += dx
                    iy += dy
                    if ix < 0 || iy < 0 || ix >= W[0].count || iy >= W.count {
                        break
                    } else {
                        visible = W[iy][ix]
                    }
                }
                if visible == .occupied {
                    nearbyOccupied += 1
                } else if visible == .empty {
                    nearbyEmpty += 1
                }
            }
        }
//        print(render(W))
        return nearbyOccupied
    }
    
    func next(_ W: World, x: Int, y: Int) -> State {
        if W[y][x] == .floor {
            return .floor
        }

        let occ = visibleOccupied(W, x: x, y: y)
        if occ == 0 {
            return .occupied
        } else if occ >= 5 {
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
        var round = 0
        while true {
            round += 1
            print("round = \(round)")
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
        let t1 = Day11.parse("""
.......#.
...#.....
.#.......
.........
..#L....#
....#....
.........
#........
...#.....
""")
        let t1a = visibleOccupied(t1, x: 3, y: 4)
        assert(8 == t1a)

        let t2 = Day11.parse("""
.............
.L.L.#.#.#.#.
.............
""")
        let t2a = visibleOccupied(t2, x: 1, y: 1)
        assert(0 == t2a)

        let t3 = Day11.parse("""
.##.##.
#.#.#.#
##...##
...L...
##...##
#.#.#.#
.##.##.
""")
        let t3a = visibleOccupied(t3, x: 3, y: 3)
        assert(0 == t3a)

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
//        let W = anneal(origin: input)
//        print(countOccupied(W))
//        let A = distribution(input)
//        assert((72, 0, 33) == A)
//        print("Part 1: \(A.0 * A.2) from distribution \(A)")
    }
    
    func part2() -> Void {
        let W = anneal(origin: input)
        let c = countOccupied(W)
        assert(2128 == c)
        print(countOccupied(W))
    }
}
