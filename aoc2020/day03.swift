//
//  day03.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-02.
//

import Foundation

let tree = "#"
let clearing = "."

//assert(7 == treeCollisions(terrainLines, 0, 0))
func treeCollisions(terrain: [String], x0: Int, y0: Int) -> Int {
    var x = x0
    var collisions = 0
    for line in terrain {
        if (line[x % line.count] == tree) {
            collisions += 1
        }
        x += 3
    }
    return collisions
}


func day03() {
    print("Day 3")
    day03test()
    do {
        // In XCode, configure Product->Scheme to set your working directory containing puzzle_input
        let filePath = FileManager.default.currentDirectoryPath
        let puzzleInput = try String(contentsOfFile: filePath + "/puzzle_input/day03.txt", encoding: String.Encoding.utf8)
        let lines = puzzleInput.split(separator:"\n")
        print(treeCollisions(terrain: lines.map{ String($0) }, x0: 0, y0: 0))
        //let validCount = countValidPasswords(lines: lines)
        //print(validCount)
//        print(checksum(expenseReport: expenseReport))
//        print(checksumHard(expenseReport: expenseReport))
    } catch {
        print("It broke")
        print(error)
    }
}

func day03test() {
    let terrain = """
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
"""
    let terrainLines = terrain.split(separator: "\n")
    assert(7 == treeCollisions(terrain: terrainLines.map{ String($0) }, x0: 0, y0: 0))
    print("Tests passed")
}
