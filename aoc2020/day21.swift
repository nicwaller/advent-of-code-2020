//
//  day21.swift
//  aoc21
//
//  Created by Nic Waller on 20-12-20.
//

import Foundation

class Day21: AOC {
    
    struct Label {
        var ingredients: Set<String>
        var allergens: Set<String>
    }
    
    static func parse(_ all: String) -> [Label] {
        return all
            .delete(["(", ")"])
            .splitOn(.newlines)
            .map{
                let parts = $0.splitOn("contains")
                let ingredients = Set(parts[0].splitOn(" "))
                let allergens = Set(parts[1].splitOn(","))
                return Label(ingredients: ingredients, allergens: allergens)
            }
    }
    
    func allergenFreeIngredients(labels: [Label]) -> Set<String> {
        var allIngredients: Set<String> = Set()
        var allAllergens: Set<String> = Set()
        for L in labels {
            allAllergens.formUnion(L.allergens)
            allIngredients.formUnion(L.ingredients)
        }
        
        var probableAllergenSources: Dictionary<String, Set<String>> = [:]
        for A in allAllergens {
//            print(A)
            let mentionedIn = labels
                .filter{ $0.allergens.contains(A) }
                .map{ $0.ingredients }
            var possibilities = mentionedIn[0]
            for P in mentionedIn {
                possibilities.formIntersection(P)
            }
            probableAllergenSources[A] = possibilities
        }
//        print(probableAllergenSources)
        
        // Now, find the least populous sets and narrow down exact answers
        var allergenSources: Dictionary<String, String> = [:]
        while probableAllergenSources.values.map({ $0.count }).reduce(0, max) >= 1 {
            let best = probableAllergenSources.filter({ $0.value.count == 1 })
            if best.count == 0 {
                break
            }
            let bestFirst = best.first!
            allergenSources[bestFirst.key] = bestFirst.value.first
            probableAllergenSources.removeValue(forKey: bestFirst.key)
            for (paKey, _) in probableAllergenSources {
                probableAllergenSources[paKey]?.remove(bestFirst.value.first!)
            }
        }
//        for (allergen, ingredient) in allergenSources {
//            print(allergen, ingredient)
//        }
        
        for L in labels {
            allAllergens.formUnion(L.allergens)
        }

        return allIngredients.subtracting(allergenSources.values)
    }
    
    func allergenicIngredients(labels: [Label]) -> Dictionary<String, String> {
        var allIngredients: Set<String> = Set()
        var allAllergens: Set<String> = Set()
        for L in labels {
            allAllergens.formUnion(L.allergens)
            allIngredients.formUnion(L.ingredients)
        }
        
        var probableAllergenSources: Dictionary<String, Set<String>> = [:]
        for A in allAllergens {
//            print(A)
            let mentionedIn = labels
                .filter{ $0.allergens.contains(A) }
                .map{ $0.ingredients }
            var possibilities = mentionedIn[0]
            for P in mentionedIn {
                possibilities.formIntersection(P)
            }
            probableAllergenSources[A] = possibilities
        }
//        print(probableAllergenSources)
        
        // Now, find the least populous sets and narrow down exact answers
        var allergenSources: Dictionary<String, String> = [:]
        while probableAllergenSources.values.map({ $0.count }).reduce(0, max) >= 1 {
            let best = probableAllergenSources.filter({ $0.value.count == 1 })
            if best.count == 0 {
                break
            }
            let bestFirst = best.first!
            allergenSources[bestFirst.key] = bestFirst.value.first
            probableAllergenSources.removeValue(forKey: bestFirst.key)
            for (paKey, _) in probableAllergenSources {
                probableAllergenSources[paKey]?.remove(bestFirst.value.first!)
            }
        }
        
        return allergenSources
    }
    
    
    
    func test() -> Void {
        let example = """
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
"""
        let P = Day21.parse(example)
        let A = allergenFreeIngredients(labels: P)
        assert(Set(["kfcds", "nhms", "sbzzf", "trh"]) == A)
        
//        let dangerousIngredientList = allergenicIngredients(labels: P)
//            .values
//            .sorted()
//            .reversed()
//            .joined(separator: ",")
//        assert("mxmxvkd,sqjhc,fvjkl" == dangerousIngredientList)
        
        print("tests OK")
    }
    

    func part1() -> Void {
        let P = Day21.parse(day21puzzleinput)
        let cleanEating = allergenFreeIngredients(labels: P)
//        let A = I.count
        var appearances = 0
        for label in P {
            for I in label.ingredients {
                if cleanEating.contains(I) {
                    appearances += 1
                }
            }
        }
        let A = appearances
        print(A)
        assert(A == 1958)
    }
    
    func part2() -> Void {
        let P = Day21.parse(day21puzzleinput)
        let dangerousIngredientList = allergenicIngredients(labels: P)
            .sorted(by: <)
            .map({ $0.value })
            .joined(separator: ",")
        print(dangerousIngredientList)
        assert("xxscc,mjmqst,gzxnc,vvqj,trnnvn,gbcjqbm,dllbjr,nckqzsg" == dangerousIngredientList)
    }
}
