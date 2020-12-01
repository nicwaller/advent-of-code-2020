//
//  day01.swift
//  aoc2020
//
//  Created by nic.home on 2020-11-30.
//

import Foundation

func checksum(expenseReport: [Int]) -> Int {
    for x in expenseReport {
        for y in expenseReport {
            if (x + y == 2020) {
                return x * y;
            }
        }
    }
    return -1;
}

func day01() {
    print("Hello, Santa!!")
    day01test();
    do {
//        let fileURL = Bundle.main.url(forResource: "day01_input", withExtension: "txt")
//        let puzzleInput = try String(contentsOf: fileURL)
        let filePath = FileManager.default.currentDirectoryPath
        let puzzleInput = try String(contentsOfFile: filePath + "/puzzle_input/day01.txt", encoding: String.Encoding.utf8)
        let expenseReport = puzzleInput.split(separator:"\n").map { Int($0)! }
        print(checksum(expenseReport: expenseReport))
    } catch {
        print("It broke")
        print(error)
    }
}

func day01test() {
    let expense_report = [
        1721,
        979,
        366,
        299,
        675,
        1456,
    ]
    assert(514579 == checksum(expenseReport: expense_report))
    print("Tests passed")
}
