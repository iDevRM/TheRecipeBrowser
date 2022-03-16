//
//  Meal.swift
//  FetchRewardsRecipeBrowser
//
//  Created by Rick Martinez on 3/9/22.
//

import Foundation

struct Meals: Codable {
    let meals: [Meal]
}

struct Meal: Codable {
    let name: String
    let image: String
    let id: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case image = "strMealThumb"
        case id = "idMeal"
    }
}
