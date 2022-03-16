//
//  Detail.swift
//  FetchRewardsRecipeBrowser
//
//  Created by Rick Martinez on 3/10/22.
//

import Foundation

struct Details: Codable {
    var meals: [[String: String?]]
}

struct Recipe {
    let name: String
    let thumbnail: String
    let instructions: String
    let ingredients: [TrueIngredient]
}

struct Ingredient {
    let key: String
    let name: String
}

struct Measurement {
    let key: String
    let amount: String
}

struct TrueIngredient {
    let name: String
    let amount: String
}

