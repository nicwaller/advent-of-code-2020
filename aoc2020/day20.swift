//
//  day20.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-20.
//

import Foundation

class Day20: AOC {
    
    struct Tile: Equatable {
        var id: Int
        var all: String
        var edgeHashes: [Int]
    }
    
    static func parse(_ all: String) -> [Tile] {
        var tiles: [Tile] = []
        let tilesTxt = all.splitOn("\n\n")
        for tileTxt in tilesTxt {
            let lines = tileTxt.splitOn(.newlines)
            let tileId = Int(lines[0].delete(["Tile ", ":"]))!
            let tileContent = lines[1 ..< lines.count]
            
            var tile: Tile = Tile(id: tileId, all: tileContent.joined(separator: "\n"), edgeHashes: [])
            tile.edgeHashes = Day20.edges(tile: tile).map{ Day20.hash(edge: $0) }
            tiles.append(tile)
        }
        return tiles
    }
    
    // produce a matchable identity regardless of rotation or mirroring
    static func hash(edge: String) -> Int {
        let binTxt = edge.replace("#", "1").replace(".", "0")
        let fwd = Int(binTxt, radix: 2)
        let rev = Int(String(binTxt.reversed()), radix: 2)
        return fwd! + rev!
    }
    
    static func edges(tile: Tile) -> [String] {
        let lines = tile.all.splitOn(.newlines)
        return [
            lines.first!,
            lines.map{ String($0.first!) }.joined(),
            lines.last!,
            lines.map{ String($0.last!) }.joined(),
        ]
    }
    
    // find any row or column by extending to all the matches
    static func extendSeries(origin: Tile, set: [Tile], axis: Int = 0) -> [Tile] {
        var line: [Tile] = [origin]
        var edgeIndex = axis
        extender: while true {
            let nextEdge = line.last!.edgeHashes[edgeIndex]
            let nextPossibles = set.filter{ $0.edgeHashes.contains(nextEdge) && $0 != line.last! }
            if nextPossibles.count == 1 {
                let next = nextPossibles.first!
                edgeIndex = next.edgeHashes.firstIndex(of: nextEdge)!
                // find the edge that is opposite the one we just matched
                edgeIndex = (edgeIndex + 2) % 4
                line.append(next)
//                let start = line.last!.edgeHashes[axis]
            } else if nextPossibles.count == 0 {
//                print("the end")
                return line
            } else {
                let myEdges = edges(tile: line.last!)
//                let myHashes = myEdges.map{ hash(edge: $0)}
                for NP in nextPossibles {
                    let posEdges = edges(tile: NP)
                    let myFwd = myEdges[edgeIndex]
                    let myRev = String(myFwd.reversed())
                    if posEdges.contains(myFwd) || posEdges.contains(myRev) {
                        let next = NP
                        edgeIndex = next.edgeHashes.firstIndex(of: nextEdge)!
                        // find the edge that is opposite the one we just matched
                        edgeIndex = (edgeIndex + 2) % 4
                        line.append(next)
                        continue extender
                    }
                }
//                print("Weird")
                return line
                // too bad?
//                print("failed, utterly")
//                print(myHashes)
//                return []
//                let betterOptions = nextPossibles.ed
//                print("too many possibilities")
//                print(edges(tile: line.last!))
//                for T in nextPossibles {
//                    print(edges(tile: T))
//                }
//                return []
            }
        }
    }
    
    struct Point2D: Hashable {
        var x: Int
        var y: Int
    }
    
    static func jigsaw(set: [Tile]) -> [[Tile]] {
        let origin: Tile = set.first!
        let rowHalf1 = Day20.extendSeries(origin: origin, set: set, axis: 0)
        let rowHalf2 = Day20.extendSeries(origin: origin, set: set, axis: 2)
        let row = rowHalf1[1 ..< rowHalf1.count].reversed() + [origin] + rowHalf2[1 ..< rowHalf2.count]
//        var result: Dictionary<Point2D, Tile> = [:]
        var result: [[Tile]] = []
        for x in 0 ..< row.count {
            var assembledRow: [Tile] = []
            let colHalf1 = Day20.extendSeries(origin: row[x], set: set, axis: 1)
            let colHalf2 = Day20.extendSeries(origin: row[x], set: set, axis: 3)
            let col = colHalf1[1 ..< colHalf1.count].reversed() + [row[x]] + colHalf2[1 ..< colHalf2.count]
            for y in 0 ..< col.count {
//                result[Point2D(x: x, y: y)] = col[y]
//                result.last()!.append(col[y])
                assembledRow.append(col[y])
            }
            result.append(assembledRow)
        }
        return result
    }
    
    static func multCorners(jigsaw: [[Tile]]) -> Int {
        return [
            jigsaw.first!.first!.id,
            jigsaw.first!.last!.id,
            jigsaw.last!.first!.id,
            jigsaw.last!.last!.id,
        ].reduce(1, *)
    }
    
//    func bounds(points: [Point2D]) -> Point2D {
//        return Point2D(x: points.map{ $0.x }.max(), y: points.map{ $0.y }.max())
//    }
    
    func test() -> Void {
        let example = """
Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...
"""
        let P = Day20.parse(example)
//        print(P)
//        let Q = Day20.extendSeries(origin: P[0], set: P)
//        print(Q)
        let J = Day20.jigsaw(set: P)
        for x in 0 ..< 3 {
            for y in 0 ..< 3 {
                print(J[x][y])
            }
        }
        let A = Day20.multCorners(jigsaw: J)
        assert(20899048083289 == A)
        print("tests OK")
    }
    

    func part1() -> Void {
        let P = Day20.parse(day20puzzleinput)
        let J = Day20.jigsaw(set: P)
        let A = Day20.multCorners(jigsaw: J)
        print("Part 1: \(A)")
        assert(43992461694439 < A)
        assert(45079100979683 == A)
    }
    
    static func nonBorderContent(_ tile: Tile) -> String {
//        return tile.all[1 ..< tile.all.count - 1]
        return ""
    }
    
    // Input: grid of tiles with incorrect rotation
    // Output: grid of tiles with correct rotation
    static func assemble(grid: [[Tile]]) -> [[Tile]] {
        let origin = grid[0][0]
        let peer = grid[0][1]
        for (i, hash) in peer.edgeHashes.enumerated() {
            if origin.edgeHashes.contains(hash) {
                print(i)
            }
        }
        return []
    }
    
    // convert a grid of tiles into an array of strings
    static func render(grid: [[Tile]]) -> [String] {
        return []
    }
    
    func part2() -> Void {
        let P = Day20.parse(day20puzzleinput)
        let J = Day20.jigsaw(set: P)
        let A = Day20.assemble(grid: J)
//        let (rules, messages) = Day20.parse(day20puzzleinput)
//        let regex = makeRegex(ruleid: 0, rules: rules)
//        print(regex)
//        let matches = messages.map{ regex.matches($0) ? 1 : 0 }.reduce(0, +)
//        print("Part 1: \(matches)")
//        assert(matches != 424)
    }
}
