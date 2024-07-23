//
//  History.swift
//  Rolling Stones
//
//  Created by Parth Antala on 2024-07-22.
//

import Foundation
import SwiftData

@Model
class History {
    var numberOfDice: Int
    var numberOfSides: Int
    var totalScore: Int
    
    init(numberOfDice: Int, numberOfSides: Int, totalScore: Int) {
        self.numberOfDice = numberOfDice
        self.numberOfSides = numberOfSides
        self.totalScore = totalScore
    }
}
