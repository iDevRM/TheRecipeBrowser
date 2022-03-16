//
//  MealsCell.swift
//  FetchRewardsRecipeBrowser
//
//  Created by Rick Martinez on 3/9/22.
//

import UIKit

class MealsCell: UITableViewCell {
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var mealLabel: UILabel!
    
    func configCell(_ meal: Meal) {
        mealLabel.text = meal.name
        if let image = meal.image.convertToImage() {
            thumbnail.image = image
        }
        mealLabel.font = UIFont.boldSystemFont(ofSize: 22)
        mealLabel.adjustsFontSizeToFitWidth = true
        mealLabel.textColor = .white
        thumbnail.layer.cornerRadius = 10
    }
}
