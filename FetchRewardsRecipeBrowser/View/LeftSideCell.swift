//
//  LeftSideCell.swift
//  FetchRewardsRecipeBrowser
//
//  Created by Rick Martinez on 3/8/22.
//

import UIKit

class LeftSideCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configCell(with category: Category) {
        categoryLabel.text = category.name
        descriptionLabel.text = category.description
        if let image = fetchImage(with: category.thumbnail) {
            thumbnail.image = image
        }
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
