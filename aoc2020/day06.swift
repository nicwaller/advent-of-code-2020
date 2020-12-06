//
//  day06.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-05.
//

import Foundation

func setify(_ chars: String) -> Set<Character> {
    var s: Set<Character> = []
    for char in chars.replacingOccurrences(of: "\n", with: "") {
        s.insert(char)
    }
    return s
}

func groupIntersection(_ chars: String) -> Set<Character> {
    let persons = chars.components(separatedBy: "\n")
    var pSets: [Set<Character>] = []
    for p in persons {
        var s: Set<Character> = []
        for c in p {
            s.insert(c)
        }
        pSets.append(s)
    }
    let commonElements = pSets.reduce(pSets.first!) { (result, list)  in
        result.intersection(list)
    }
    return commonElements
}


func day06() {
    day06test()
    let groups = day6puzzleInput.components(separatedBy: "\n\n")
    let total = groups.map{ setify($0).count }.reduce(0, +)
    assert(6549 == total)
    print(total)
    
    let ag = groups.map{ groupIntersection($0) }
    print(ag)
    let t2 = ag.map{ $0.count }.reduce(0, +)
    assert(3466 == t2)
    print(t2)
}

func day06test() {
    assert(3 == groupIntersection("abc").count)
    assert(0 == groupIntersection("a\nb\nc").count)
    assert(1 == groupIntersection("ab\nac").count)
}
