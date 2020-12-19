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
        case repetition(Int)
        case fuck(Int, Int)
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
        
        rules[8] = Rule.repetition(42)
        if rules[11] != nil {
            print("eleven!")
            print(rules[11]!)
            rules[11] = Rule.fuck(42, 31)
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
        case .repetition(let id):
            let subr = rules[id]!
            return makeRegexStr(subr, rules: rules) + "+"
        case .fuck(let left, let right):
            let leftEx: String = makeRegexStr(rules[left]!, rules: rules)
            let rightEx: String = makeRegexStr(rules[right]!, rules: rules)
            var opts: [String] = []
            for i in 1 ... 10 {
                opts.append(String(repeating: leftEx, count: i) + String(repeating: rightEx, count: i))
            }
            return "(" + opts.joined(separator: "|") + ")"
        }
    }
    
    func makeRegex(ruleid: Int, rules: Dictionary<Int, Rule>) -> NSRegularExpression {
        let rStr = makeRegexStr(rules[ruleid]!, rules: rules)
        let regex = try! NSRegularExpression(pattern: "^" + rStr + "$")
        return regex
    }
    
    func test() -> Void {
        let example = """
42: 9 14 | 10 1
9: 14 27 | 1 26
10: 23 14 | 28 1
1: "a"
11: 42 31
5: 1 14 | 15 1
19: 14 1 | 14 14
12: 24 14 | 19 1
16: 15 1 | 14 14
31: 14 17 | 1 13
6: 14 14 | 1 14
2: 1 24 | 14 4
0: 8 11
13: 14 3 | 1 12
15: 1 | 14
17: 14 2 | 1 7
23: 25 1 | 22 14
28: 16 1
4: 1 1
20: 14 14 | 1 15
3: 5 14 | 16 1
27: 1 6 | 14 18
14: "b"
21: 14 1 | 1 14
25: 1 1 | 1 14
22: 14 14
8: 42
26: 14 22 | 1 20
18: 15 15
7: 14 5 | 1 21
24: 14 1

abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaaaabbaaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
babaaabbbaaabaababbaabababaaab
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
"""
        let (rules, messages) = Day19.parse(example)
        let regex = makeRegex(ruleid: 0, rules: rules)
        print(regex)
        assert(true == regex.matches("bbabbbbaabaabba"))
        assert(true == regex.matches("babbbbaabbbbbabbbbbbaabaaabaaa"))
        assert(true == regex.matches("aaabbbbbbaaaabaababaabababbabaaabbababababaaa"))
        assert(true == regex.matches("bbbbbbbaaaabbbbaaabbabaaa"))
        assert(true == regex.matches("bbbababbbbaaaaaaaabbababaaababaabab"))
        assert(true == regex.matches("ababaaaaaabaaab"))
        assert(true == regex.matches("ababaaaaabbbaba"))
        assert(true == regex.matches("baabbaaaabbaaaababbaababb"))
        assert(true == regex.matches("abbbbabbbbaaaababbbbbbaaaababb"))
        assert(true == regex.matches("aaaaabbaabaaaaababaa"))
        assert(true == regex.matches("aaaabbaabbaaaaaaabbbabbbaaabbaabaaa"))
        assert(true == regex.matches("aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba"))
        
        assert(false == regex.matches("abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa"))
        assert(false == regex.matches("aaaabbaaaabbaaa"))
        assert(false == regex.matches("babaaabbbaaabaababbaabababaaab"))
        
        let matches = messages.map{ regex.matches($0) ? 1 : 0 }.reduce(0, +)
        assert(12 == matches)

        print("tests OK")
    }
    
//    func isMatch(msg: String, rule: Rule, rules: Dictionary<Int, Rule>) -> (Bool, String) {
//        switch rule {
//        case .literal(let lit):
//            return (msg == lit, lit)
//        case .any(let subRules):
//            for R in subRules {
//                if isMatch(msg: msg, rule: R, rules: rules) {
//                    return true
//                }
//            }
//            return false
//        case .sub(let subId):
//            return isMatch(msg: msg, rule: rules[subId]!, rules: rules)
//        case .series(let series):
//
//        default:
//            <#code#>
//        }
//    }
    

    func part1() -> Void {
    }
    
    func part2() -> Void {
        let (rules, messages) = Day19.parse(day19puzzleinput)
        let regex = makeRegex(ruleid: 0, rules: rules)
        print(regex)
        let matches = messages.map{ regex.matches($0) ? 1 : 0 }.reduce(0, +)
        print("Part 1: \(matches)")
        assert(matches != 424)
    }
}
