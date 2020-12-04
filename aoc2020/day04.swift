//
//  day04.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-03.
//

import Foundation

typealias Passport = Dictionary<String, String>

let passportRequiredFields: Set = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

func isValidPassport(_ passport:Passport) -> Bool {
    let keysPresent = Set(passport.keys).intersection(passportRequiredFields)
    return (keysPresent == passportRequiredFields)
}

func decodePassport(_ lines:[String]) -> Passport {
    var passport: Passport = Dictionary()
    for line in lines {
        for field in line.components(separatedBy: " ") {
            let foo = field.components(separatedBy: ":")
            let key = foo[0]
            let value = foo[1]
            passport[key] = value
        }
    }
    return passport
}

func decodePassport(_ text:String) -> Passport {
    return decodePassport(text.components(separatedBy: .newlines))
}

func splitPassports(_ input:String) -> [Passport] {
    let lines = input.components(separatedBy: .newlines)
    var relatedLines: [String] = []
    var passports: [Passport] = []
    for line in lines {
        if line != "" {
            relatedLines.append(line)
        } else {
            passports.append(decodePassport(relatedLines))
            relatedLines = []
        }
    }
    if relatedLines.count > 0 {
        passports.append(decodePassport(relatedLines))
        relatedLines = []
    }
    return passports
}

func day04() {
    day04test()
    let validPassports = splitPassports(day4puzzleInput).map { isValidPassport($0) ? 1 : 0 }.reduce(0, +)
    assert(254 == validPassports)
    print(validPassports)
}

func day04test() {
    assert(true == isValidPassport(decodePassport("""
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm
""")))
    assert(false == isValidPassport(decodePassport("""
iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929
""")))
    assert(true == isValidPassport(decodePassport("""
hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm
""")))
    assert(false == isValidPassport(decodePassport("""
hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
""")))

}
