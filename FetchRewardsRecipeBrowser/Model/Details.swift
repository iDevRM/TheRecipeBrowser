//
//  Detail.swift
//  FetchRewardsRecipeBrowser
//
//  Created by Rick Martinez on 3/10/22.
//

import Foundation

struct Details: Codable {
    var details: [[String: String?]]
    
    private enum CodingKeys: String, CodingKey {
        case details = "meals"
    }
}

struct Recipe {
    let thumbnail: String
    let instructions: String
    let ingredients: [String]
    let measurements: [String]
}
