//
//  day04.swift
//  aoc2020
//
//  Created by nic.home on 2020-12-03.
//

import Foundation

typealias Passport = Dictionary<String, String>

func isValidPassport(_ passport:Passport) -> Bool {
    let passportRequiredFields: Set = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    let keysPresent = Set(passport.keys).intersection(passportRequiredFields)
    return (keysPresent == passportRequiredFields)
}

func isVeryValidPassport(_ passport:Passport) -> Bool {
    if (!isValidPassport(passport)) {
        return false
    }

    guard let birthYear = Int(passport["byr"]!) else { return false }
    guard let issueYear = Int(passport["iyr"]!) else { return false }
    guard let expirationYear = Int(passport["eyr"]!) else { return false }
    guard let height = Int(passport["hgt"]!
                    .components(separatedBy:CharacterSet.decimalDigits.inverted)
                            .joined()) else { return false }
    
    if !(1920 ... 2002 ~= birthYear) {
        return false
    }
    if !(2010 ... 2020 ~= issueYear) {
        return false
    }
    if !(2020 ... 2030 ~= expirationYear) {
        return false
    }
    if passport["hgt"]!.hasSuffix("cm") {
        if (height < 150) {
            return false
        }
        if (height > 193) {
            return false
        }
    } else if passport["hgt"]!.hasSuffix("in") {
        if (height < 59) {
            return false
        }
        if (height > 76) {
            return false
        }
    } else {
        print("weird hgt value = \(passport["hgt"]!)")
        return false
    }

    if !(passport["hcl"]! ~= "^#[a-z0-9]{6}$") {
        return false
    }
    if !["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(passport["ecl"]!) {
        return false
    }
    if !(passport["pid"]! ~= "^[0-9]{9}$") {
        return false
    }

    return true
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
    let veryValidPassports = splitPassports(day4puzzleInput).map { isVeryValidPassport($0) ? 1 : 0 }.reduce(0, +)
    assert(veryValidPassports < 187)
    assert(veryValidPassports < 185)
    assert(veryValidPassports == 184)
    print("veryValidPassports \(veryValidPassports)")
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

    assert(false == isVeryValidPassport(decodePassport("""
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926
""")))
    assert(false == isVeryValidPassport(decodePassport("""
iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946
""")))
    assert(false == isVeryValidPassport(decodePassport("""
hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277
""")))
    assert(false == isVeryValidPassport(decodePassport("""
hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007
""")))
    
    assert(true == isVeryValidPassport(decodePassport("""
pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f
""")))
    assert(true == isVeryValidPassport(decodePassport("""
eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm
""")))
    assert(true == isVeryValidPassport(decodePassport("""
hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022
""")))
    assert(true == isVeryValidPassport(decodePassport("""
iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
""")))

}

extension String {
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}
