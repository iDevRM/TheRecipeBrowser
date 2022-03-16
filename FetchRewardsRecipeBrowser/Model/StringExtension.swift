//
//  StringExtension.swift
//  FetchRewardsRecipeBrowser
//
//  Created by Rick Martinez on 3/15/22.
//

import Foundation
import UIKit

extension String {
    func convertToImage() -> UIImage? {
        guard let url = URL(string: self) else { return nil }
        
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
}
