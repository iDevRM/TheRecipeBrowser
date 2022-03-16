//
//  LeftSideCell.swift
//  FetchRewardsRecipeBrowser
//
//  Created by Rick Martinez on 3/8/22.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configCell(with category: Category) {
        categoryLabel.text = category.name
        descriptionLabel.text = category.description
        if let image = category.thumbnail.convertToImage() {
            thumbnail.image = image
        }
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        thumbnail.layer.cornerRadius = 10
    }
}
