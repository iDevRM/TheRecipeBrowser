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
    
    var recipe: Recipe?
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
                    self.tableView.reloadData()
                }
            }
        }
        print("recipe instructions are \(recipe?.instructions)")
        instructionLabel.text = recipe?.instructions

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
       
        return 5
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
            
            cell.configCell(ingredient: "cake", measurement: "2 Cups")
            return cell
        }
        return UITableViewCell()
    }
}
