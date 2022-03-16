//
//  IngredientCell.swift
//  FetchRewardsRecipeBrowser
//
//  Created by Rick Martinez on 3/10/22.
//

import UIKit

class IngredientCell: UITableViewCell {
    
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var measurementLabel: UILabel!
    
    func configCell(with ingredient: TrueIngredient) {
        ingredientLabel.text = ingredient.name
        measurementLabel.text = ingredient.amount
    }
    
}
