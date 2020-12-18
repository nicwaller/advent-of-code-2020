//
//  day18.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-18.
//

import Foundation

class Day18: AOC {
    
    typealias Expression = [Token]
    enum Token: Equatable {
        case open
        case close
        case value(Int)
        case add
        case multiply
    }
    
    static func parseLine(_ line: String) -> Expression {
        var exp: Expression = []
        for c in line {
            switch c {
            case "(":
                exp.append(.open)
                break
            case ")":
                exp.append(.close)
                break
            case _ where ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains(c):
                exp.append(.value(Int(String(c))!))
                break
            case "+":
                exp.append(.add)
                break
            case "*":
                exp.append(.multiply)
                break
            case " ":
                continue
            default:
                print("Not handled")
            }
        }
        return exp
    }
    
    static func parse(_ all: String) -> [Expression] {
        return all.splitOn(.newlines).map{ parseLine($0) }
    }
    
//    func firstParenPhrase(_ S: Expression) -> Optional<(Expression)> {
//        if !S.contains("(") {
//            return nil
//        }
//        var lParen = -1
//        var rParen = -1
//        var depth =
//        for c in S {
//
//        }
//        let X = "sdf"[2..<3]
//    }
    
    // I used Swift discriminated unions wrong here
    // https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html
    func extract(_ T: Token) -> Optional<Int> {
        switch T {
        case .value(let x):
            return x
        default:
            print("cannot extract non-value")
            return nil
        }
    }
    
    func eval(_ E: Expression) -> Optional<Int> {
        var simpleExpression: Expression = []
        var depth = 0
        var pOpen: Optional<Int> = nil
        var pClose: Optional<Int> = nil
        // Part 1, reduce sub expressions
        for (i, c) in E.enumerated() {
            switch c {
            case .open:
                if depth == 0 {
                    pOpen = i
                }
                depth += 1
            case .close:
                pClose = i
                depth -= 1
                if depth == 0 {
                    guard pOpen != nil else {
                        print("mismatched parens?")
                        return nil
                    }
                    let subExpression = Array(E[pOpen! + 1 ... pClose! - 1])
                    guard let subResult = eval(subExpression) else {
                        print("failed to eval subexpr?")
                        return nil
                    }
                    simpleExpression.append(.value(subResult))
                }
            default:
                if depth == 0 {
                    simpleExpression.append(E[i])
                }
            }
        }
        
        // Part 2, do the math
        while simpleExpression.count > 1 {
            let x = extract(simpleExpression[0])!
            let y = extract(simpleExpression[2])!

            var result: Optional<Int> = nil
            switch simpleExpression[1] {
            case .add:
                result = x + y
                break
            case .multiply:
                result = x * y
                break
            default:
                print("unknown")
                return nil
            }
            simpleExpression.replaceSubrange(0 ... 2, with: [ Day18.Token.value(result!) ])
        }
        return extract(simpleExpression[0])
    }

    func evalstr(_ S: String) -> Optional<Int> {
        return eval(Day18.parseLine(S))
    }
    
    func test() -> Void {
        assert(71 == evalstr("1 + 2 * 3 + 4 * 5 + 6"))
        assert(44 == evalstr("(4 * (5 + 6))"))
        assert(51 == evalstr("1 + (2 * 3) + (4 * (5 + 6))"))
        assert(26 == evalstr("2 * 3 + (4 * 5)"))
        assert(437 == evalstr("5 + (8 * 3 + 9 + 3 * 4 * 3)"))
        assert(12240 == evalstr("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"))
        assert(13632 == evalstr("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"))
        print("tests OK")
    }
    

    func part1() -> Void {
        let P = Day18.parse(day18puzzleinput)
        print(P)
        let A = P.map{ eval($0)! }.reduce(0, +)
        print("Part 1: \(A)")
//        assert(A == 291)
    }
    
    func part2() -> Void {
//        var P = Day18.parse(day18puzzleinput)
//        print(P)
//
//
//        let A = P.count
//        print("Part 2: \(A)")
////        assert(A == 291)
    }
}
