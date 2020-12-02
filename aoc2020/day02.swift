//
//  day02.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-01.
//

import Foundation

// shamelessly cribbed from https://gist.githubusercontent.com/unshapedesign/1b95f78d7f74241f706f346aed5384ff/raw/17145f12fbde8f9aa89f6ed8b69d794dedbdf245/gistfile1.txt
public extension String {
    
    /**
     String extension that extract the captured groups with a regex pattern
     
     - parameter pattern: regex pattern
     - Returns: captured groups
     */
    func capturedGroups(withRegex pattern: String) -> [String] {
        var results = [String]()
        
        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return results
        }
        let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count))
        
        guard let match = matches.first else { return results }
        
        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return results }
        
        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.range(at: i)
            let matchedString = (self as NSString).substring(with: capturedGroupIndex)
            results.append(matchedString)
        }
        
        return results
    }

}

extension String {
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }

    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript (r: Range<Int>) -> Substring {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start..<end]
    }

    subscript (r: ClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start...end]
    }
}

func isValidPassword(min: Int, max: Int, char: Character, password: String) -> Bool {
    let occurs = password.map{ $0 == char ? 1 : 0 }.reduce(0, +)
    return (min <= occurs) && (max >= occurs)
}

func altValidPassword(p1: Int, p2: Int, char: Character, password: String) -> Bool {
    return (password[p1-1] == char) != (password[p2-1] == char)
}

func countValidPasswords(lines: [Substring]) -> Int {
    // let regex = try! NSRegularExpression(pattern: "^([0-9]*)-([0-9]*) (.): (.*)$")
    var countValid = 0
    for line in lines {
        let haystack = String(line)
        let result = haystack.capturedGroups(withRegex: "^([0-9]*)-([0-9]*) (.): (.*)$")
//        let result = regex.matches(in:haystack, range:NSMakeRange(0, haystack.utf16.count))
        print(result)
        let min = Int(result[0])!
        let max = Int(result[1])!
        let char = Character(result[2])
        let password = result[3]
        let valid = altValidPassword(p1: min, p2: max, char: char, password: password)
        if (valid) {
            countValid += 1
        }
    }
    return countValid
}

func day02() {
    print("Day 2")
    day02test()
    do {
        // In XCode, configure Product->Scheme to set your working directory containing puzzle_input
        let filePath = FileManager.default.currentDirectoryPath
        let puzzleInput = try String(contentsOfFile: filePath + "/puzzle_input/day02.txt", encoding: String.Encoding.utf8)
        let lines = puzzleInput.split(separator:"\n")
        let validCount = countValidPasswords(lines: lines)
        print(validCount)
//        print(checksum(expenseReport: expenseReport))
//        print(checksumHard(expenseReport: expenseReport))
    } catch {
        print("It broke")
        print(error)
    }
}

func day02test() {
    assert(true == isValidPassword(min: 1, max: 3, char: "a", password: "abcde"))
    assert(false == isValidPassword(min: 1, max: 3, char: "b", password: "cdefg"))
    assert(true == isValidPassword(min: 2, max: 9, char: "c", password: "ccccccccc"))
    assert(true == altValidPassword(p1: 1, p2: 3, char: "a", password: "abcde"))
    assert(false == altValidPassword(p1: 1, p2: 3, char: "b", password: "cdefg"))
    assert(false == altValidPassword(p1: 2, p2: 9, char: "c", password: "ccccccccc"))
    
    print("Tests passed")
}

// part 2 answer is NOT 636
