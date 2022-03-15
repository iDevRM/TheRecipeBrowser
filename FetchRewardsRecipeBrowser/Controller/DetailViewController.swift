//
//  DetailViewController.swift
//  FetchRewardsRecipeBrowser
//
//  Created by Rick Martinez on 3/10/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var recipe = Recipe(name: "", thumbnail: "", instructions: "", ingredients: [], measurements: [])
    var mealId = ""
    var networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        networkManager.fetchDetails(networkManager.configUrlString(.byID, with: mealId)) { result in
            switch result {
            case .failure(let error):
                debugPrint(error.localizedDescription)
            case .success(let recipe):
                self.recipe = recipe
                DispatchQueue.main.async {
                    self.thumbnail.image = self.fetchImage(with: recipe.thumbnail)
                    self.thumbnail.layer.cornerRadius = 10
                    self.nameLabel.text = recipe.name
                    self.instructionLabel.text = recipe.instructions
                    self.tableView.reloadData()
                }
            }
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

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return recipe.ingredients.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ingredients"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as? IngredientCell {
            
            cell.configCell(ingredient:recipe.ingredients[indexPath.row].name, measurement: recipe.measurements[indexPath.row].amount)
            return cell
        }
        return UITableViewCell()
    }
}
