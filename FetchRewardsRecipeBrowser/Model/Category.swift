//
//  Category.swift
//  FetchRewardsRecipeBrowser
//
//  Created by Rick Martinez on 3/8/22.
//

import Foundation

struct Categories: Codable {
    let categories: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let thumbnail: String
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case thumbnail = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
}


