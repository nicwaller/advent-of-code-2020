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
    
    
    var gameCounter = 0
    
    func recursiveCombat(players: [Deck], depth: Int = 0) -> (Int, Deck) {
        let game = (depth == 0) ? 1 : gameCounter + 1
        gameCounter = game

        print("=== Game \(game) ===")
        var p1 = players[0]
        var p2 = players[1]
        
        var seen1: Set<[Int]> = Set()
        var seen2: Set<[Int]> = Set()
        
        var round = 1
        while p1.count > 0 && p2.count > 0 {
            if seen1.contains(p1) && seen2.contains(p2) {
                print("Player 1 wins by acclamation! (dupe set list)")
                return (1, p1)
            } else {
                seen1.insert(p1)
                seen2.insert(p2)
            }

            print("\n-- Round \(round) (Game \(game)) --")
            print("Player 1's deck: \(p1.map{ String($0) }.joined(separator: ", "))")
            print("Player 2's deck: \(p2.map{ String($0) }.joined(separator: ", "))")

            let a = p1.removeFirst()
            let b = p2.removeFirst()
            print("Player 1 plays: \(a)")
            print("Player 2 plays: \(b)")

            var winner: Int? = nil
            if p1.count >= a && p2.count >= b {
                print("Playing a sub-game to determine the winner...")
                (winner, _) = recursiveCombat(players: [
                    Array(p1[0 ..< a]),
                    Array(p2[0 ..< b]),
                ], depth: depth + 1)
                print("...anyway, back to game \(game).")
            } else {
                winner = a > b ? 1 : 2
            }
            
            if winner == 1 {
                print("Player 1 wins round \(round) of game \(game)!")
                p1.append(a)
                p1.append(b)
            } else if winner == 2 {
                print("Player 2 wins round \(round) of game \(game)!")
                p2.append(b)
                p2.append(a)
            } else {
                print("wtf")
            }

            round += 1
        }
        if p1.count > p2.count {
            print("The winner of game \(game) is player 1!")
            return (1, p1)
        } else {
            print("The winner of game \(game) is player 2!")
            return (2, p2)
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
        
        let (_, winningDeck) = recursiveCombat(players: P, depth: 1)
        let A2 = Day22.scoreDeck(deck: winningDeck)
        print("Test 2: \(A2)")
        assert(291 == A2)

        print("tests OK")
    }
    

    func part1() -> Void {
//        let P = Day22.parse(day22puzzleinput)
//        let W = Day22.war(players: P)
//        let A = Day22.scoreDeck(deck: W)
//        print(A)
    }
    
    func part2() -> Void {
        let P = Day22.parse(day22puzzleinput)
        let (_, winningDeck) = recursiveCombat(players: P)
        let A = Day22.scoreDeck(deck: winningDeck)
        print("Part 2: \(A)")
        assert(33745 != A)
    }
    
}
