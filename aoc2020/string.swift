//
//  string.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-07.
//

import Foundation

public extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func trim(_ chars: CharacterSet) -> String {
        return self.trimmingCharacters(in: chars)
    }
    func trim(_ chars: String) -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: chars))
    }
    func replace(_ needle: String, _ replacement: String) -> String {
        return self.replacingOccurrences(of: needle, with: replacement)
    }
    func splitOn(_ delimiters: CharacterSet, trimWhitespace: Bool = true) -> [String] {
        if trimWhitespace {
            return self.components(separatedBy: delimiters).map{ $0.trim(.whitespaces) }
        } else {
            return self.components(separatedBy: delimiters)
        }
    }
    func splitOn(_ delimiter: String, trimWhitespace: Bool = true) -> [String] {
        if trimWhitespace {
            return self.components(separatedBy: delimiter).map{ $0.trim(.whitespaces) }
        } else {
            return self.components(separatedBy: delimiter)
        }
    }
    func delete(_ phrases: [String]) -> String {
        var converted = String(self)
        for needle in phrases {
            converted = converted.replace(needle, "")
        }
        return converted
    }
    func take(_ count: Int) -> (String, String) {
        let splitIndex: String.Index = self.index(self.startIndex, offsetBy: count)
        let taken = String(self[..<splitIndex])
        let remainder = String(self[splitIndex...])
        return (taken, remainder)
    }
}

func testStringExtensions() {
    assert("foo".trim("o") == "f")
}
