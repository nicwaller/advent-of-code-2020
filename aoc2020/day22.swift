//
//  day22.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-22.
//

import Foundation


class Day22: AOC {
    
    typealias Deck = [Int]
        
    static func parse(_ all: String) -> [Deck] {
        var decks: [Deck] = []
        let sections = all.splitOn("\n\n")
        for section in sections {
            let parts = section.splitOn(":")
            let playerName = parts[0]
            print(playerName)
            let deck: Deck = parts[1].splitOn(.newlines).filter{ $0 != "" }.map{ Int($0)! }
            decks.append(deck)
        }
        return decks
    }
    
    static func war(players: [Deck]) -> Deck {
        var p1 = players[0]
        var p2 = players[1]
        
        while p1.count > 0 && p2.count > 0 {
            let a = p1.removeFirst()
            let b = p2.removeFirst()
            if a > b {
                p1.append(max(a, b))
                p1.append(min(a, b))
            } else if a < b {
                p2.append(max(a, b))
                p2.append(min(a, b))
            } else if a == b {
                print("ties are impossible")
            } else {
                print("wtf")
            }
        }
        if p1.count > p2.count {
            return p1
        } else {
            return p2
        }
    }
    
    static func scoreDeck(deck: Deck) -> Int {
        var score = 0
        for (idx, cardVal) in deck.reversed().enumerated() {
            score += (idx + 1) * cardVal
        }
        return score
    }
        
    func test() -> Void {
        let example = """
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
"""
        let P = Day22.parse(example)
        let W = Day22.war(players: P)
        let A = Day22.scoreDeck(deck: W)
        assert(306 == A)
        print("tests OK")
    }
    

    func part1() -> Void {
        let P = Day22.parse(day22puzzleinput)
        let W = Day22.war(players: P)
        let A = Day22.scoreDeck(deck: W)
        print(A)
    }
    
    func part2() -> Void {
    }
    
}
