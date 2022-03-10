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
        if let image = fetchImage(with: meal.image) {
            thumbnail.image = image
        }
        mealLabel.font = UIFont.systemFont(ofSize: 25)
        mealLabel.textColor = .white
        thumbnail.layer.cornerRadius = 10
    }
    
    private func fetchImage(with string: String) -> UIImage? {
        guard let url = URL(string: string) else { return nil }
        
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
    

}
