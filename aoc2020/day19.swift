//
//  day19.swift
//  aoc2020
//
//  Created by Nic Waller on 2020-12-19.
//

import Foundation

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

class Day19: AOC {
    
    enum Rule {
        case literal(String)
        case any([Rule])
        case series([Rule])
        indirect case sub(Int)
    }
        
    typealias Message = String
    
    static func parseRule(_ rule: String) -> Rule {
        let c = rule.splitOn(" ").count
        if c == 1 && rule.contains("\"") {
            return Rule.literal(String(rule.delete(["\""])))
        } else if rule.contains("|") {
            let opts = rule.splitOn("|").map{ parseRule($0) }
            return Rule.any(opts)
        } else if c > 1 {
            return Rule.series(rule.splitOn(" ").map{ parseRule($0) })
        } else if c == 1 {
            return Rule.sub( Int(rule)! )
        } else {
            print("unexpected")
            return Rule.sub( -1 )
        }
    }

    static func parse(_ all: String) -> (Dictionary<Int, Rule>, [Message]) {
        let sections = all.splitOn("\n\n")
        
        // TODO: guard let???
        var messages: [Message] = []
        if sections.count == 2 {
            messages = sections[1].splitOn(.newlines)
        }

        let rulesTxt = sections[0].splitOn(.newlines)
        var rules: Dictionary<Int, Rule> = [:]
        for line in rulesTxt {
            // TODO: write a takeTo(delim:) string extension
            let parts: [String] = line.splitOn(":")
            let ruleId: Int = Int(parts[0])!
            let ruleTxt: String = parts[1]
            let R = parseRule(ruleTxt)
            rules[ruleId] = R
        }
        
        return (rules, messages)
    }
    
//    func matches(message: String, rule: Rule, rules: Dictionary<Int, Rule>) -> Bool {
//        switch rule {
//        case .literal(let lit):
//            return message == lit
//        case .any(let subs):
//            for r in subs {
//                if matches(message: message, rule: r, rules: rules) {
//                    return true
//                }
//            }
//            return false
//        case .series(<#T##[Rule]#>)
//        default:
//            <#code#>
//        }
//    }

//    func matches(message: String, ruleno: Int, rules: Dictionary<Int, Rule>) -> Bool {
//        let rule = rules[ruleno]
//        switch rule {
//        case .literal(let lit):
//            return message == lit
//        case .any(let subs):
//            for r in subs {
//                if matches(message: message, ruleno: , rules: <#T##Dictionary<Int, Rule>#>)
//            }
//        default:
//            <#code#>
//        }
//    }
    
    func makeRegexStr(_ R: Rule, rules: Dictionary<Int, Rule> = [:]) -> String {
        switch R {
        case .literal(let lit):
            return lit
        case .any(let subRules):
            return "(" + subRules.map{ makeRegexStr($0, rules: rules) }.joined(separator: "|") + ")"
        case .series(let subRules):
            return subRules.map{ makeRegexStr($0, rules: rules) }.joined(separator: "")
        case .sub(let id):
            guard let subr = rules[id] else {
//                print(id)
//                print(rules)
                return ""
            }
            return makeRegexStr(subr, rules: rules)
        }
    }
    
    func makeRegex(ruleid: Int, rules: Dictionary<Int, Rule>) -> NSRegularExpression {
        let rStr = makeRegexStr(rules[ruleid]!, rules: rules)
        let regex = try! NSRegularExpression(pattern: "^" + rStr + "$")
        return regex
    }
    
    func test() -> Void {
        let example = """
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
"""
        let (rules, messages) = Day19.parse(example)
        let regex = makeRegex(ruleid: 0, rules: rules)
        print(regex)
        assert(true == regex.matches("ababbb"))
        assert(true == regex.matches("abbbab"))
        assert(false == regex.matches("bababa"))
        assert(false == regex.matches("aaabbb"))
        assert(false == regex.matches("aaaabbb"))
        print("tests OK")
    }
    

    func part1() -> Void {
        let (rules, messages) = Day19.parse(day19puzzleinput)
        let regex = makeRegex(ruleid: 0, rules: rules)
        var matches = 0
        for M in messages {
            let range = NSRange(location: 0, length: M.utf8.count)
            if regex.firstMatch(in: M, options: [], range: range) != nil {
                matches += 1
            }
        }
        print("Part 1: \(matches)")
        assert(matches == 299)
    }
    
    func part2() -> Void {
    }
}
