//
//  day17.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-17.
//

import Foundation

class Day17: AOC {
    
    struct Point4D: Hashable {
        var x: Int
        var y: Int
        var z: Int
        var w: Int
    }

    typealias Bounds4D = (ClosedRange<Int>, ClosedRange<Int>, ClosedRange<Int>, ClosedRange<Int>)
    typealias Cube = Set<Point4D>
    
    static func parse(_ all: String) -> Cube {
        var C: Cube = Set()
        for (y, row) in all.splitOn(.newlines).enumerated() {
            for (x, char) in row.enumerated() {
                if char == "#" {
                    C.insert(Point4D(x: x, y: y, z: 0, w: 0))
                }
            }
        }
        return C
    }
    
    func calcBounds(_ C: Cube, extend: Int = 0) -> Bounds4D {
        let basis = C.first!

        var minX = basis.x, maxX = basis.x
        var minY = basis.y, maxY = basis.y
        var minZ = basis.z, maxZ = basis.z
        var minW = basis.w, maxW = basis.w
        
        for P in C {
            minX = min(minX, P.x)
            maxX = max(maxX, P.x)
            minY = min(minY, P.y)
            maxY = max(maxY, P.y)
            minZ = min(minZ, P.z)
            maxZ = max(maxZ, P.z)
            minW = min(minW, P.w)
            maxW = max(maxW, P.w)
        }
        
        minX -= extend
        maxX += extend
        minY -= extend
        maxY += extend
        minZ -= extend
        maxZ += extend
        minW -= extend
        maxW += extend

        return ( minX ... maxX, minY ... maxY, minZ ... maxZ, minW ... maxW )
    }
    
    func activeNeighbours(_ C: Cube, at: Point4D) -> Set<Point4D> {
        var neighbours: Set<Point4D> = Set()
        for x in at.x - 1 ... at.x + 1 {
            for y in at.y - 1 ... at.y + 1 {
                for z in at.z - 1 ... at.z + 1 {
                    for w in at.w - 1 ... at.w + 1 {
                        let P = Point4D(x: x, y: y, z: z, w: w)
                        if P == at {
                            continue
                        }
                        if C.contains(P) {
                            neighbours.insert(P)
                        }
                    }
                }
            }
        }
        return neighbours
    }
    
    func advance(_ C: Cube) -> Cube {
        let bounds = calcBounds(C, extend: 1)
        var newWorld: Cube = Set()
        for x in bounds.0 {
            for y in bounds.1 {
                for z in bounds.2 {
                    for w in bounds.3 {
                        let P = Point4D(x: x, y: y, z: z, w: w)
                        let neighbours = activeNeighbours(C, at: P)
                        var newIsActive: Optional<Bool> = nil
                        if C.contains(P) {
                            if neighbours.count >= 2 && neighbours.count <= 3 {
                                newIsActive = true
                            } else {
                                newIsActive = false
                            }
                        } else {
                            if neighbours.count == 3 {
                                newIsActive = true
                            } else {
                                newIsActive = false
                            }
                        }
                        if newIsActive! {
                            newWorld.insert(P)
                        }
                    }
                }
            }
        }
        return newWorld
    }
    
    // returns an array of planes
//    func renderCube(_ C: Cube) -> String {
//        let bounds = calcBounds(C)
//        print(bounds)
//        var planes: [String] = []
//        for z in bounds.2 {
//            var lines: [String] = []
//            for y in bounds.1 {
//                var line: [String] = []
//                for x in bounds.0 {
//                    let P = Point4D(x: x, y: y, z: z)
//                    if C.contains(P) {
//                        line.append("#")
//                    } else {
//                        line.append(".")
//                    }
//                }
//                lines.append(line.joined(separator: ""))
//            }
//            planes.append(lines.joined(separator: "\n"))
//        }
//        return planes.joined(separator: "\n\n")
//    }
            
    func test() -> Void {
        let example = """
.#.
..#
###
"""
        var P = Day17.parse(example)
//        print(renderCube(P))
        for _ in 1 ... 6 {
           P = advance(P)
        }
        assert(848 == P.count)

//        print("---")
//        let P1 = advance(P)
//        print(renderCube(P1))
//        print(P)
        print("tests OK")
    }

    func part1() -> Void {
    }
    
    func part2() -> Void {
        var P = Day17.parse(day17puzzleinput)
        print(P)
        for _ in 1 ... 6 {
            P = advance(P)
        }
        print(P)
        let A = P.count
        print("Part 2: \(A)")
//        assert(A == 291)
    }
}
