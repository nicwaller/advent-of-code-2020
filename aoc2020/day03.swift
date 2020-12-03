//
//  day03.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-02.
//

import Foundation

let tree = "#"
let clearing = "."

func treeCollisions(terrain: [String], vx: Int, vy: Int) -> Int {
    var x = 0
    var collisions = 0
    for lineno in 0..<terrain.count where lineno % vy == 0 {
        let line = terrain[lineno]
        if (line[x % line.count] == tree) {
            collisions += 1
        }
        x += vx
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
        print(treeCollisions(terrain: lines.map{ String($0) }, vx: 3, vy: 1))
        print(1
                * treeCollisions(terrain: lines.map{ String($0) }, vx: 1, vy: 1)
                * treeCollisions(terrain: lines.map{ String($0) }, vx: 3, vy: 1)
                * treeCollisions(terrain: lines.map{ String($0) }, vx: 5, vy: 1)
                * treeCollisions(terrain: lines.map{ String($0) }, vx: 7, vy: 1)
                * treeCollisions(terrain: lines.map{ String($0) }, vx: 1, vy: 2)
        )
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
    assert(2 == treeCollisions(terrain: terrainLines.map{ String($0) }, vx: 1, vy: 1))
    assert(7 == treeCollisions(terrain: terrainLines.map{ String($0) }, vx: 3, vy: 1))
    assert(3 == treeCollisions(terrain: terrainLines.map{ String($0) }, vx: 5, vy: 1))
    assert(4 == treeCollisions(terrain: terrainLines.map{ String($0) }, vx: 7, vy: 1))
    assert(2 == treeCollisions(terrain: terrainLines.map{ String($0) }, vx: 1, vy: 2))
    print("Tests passed")
}
