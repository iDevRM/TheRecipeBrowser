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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var recipe = Recipe(name: "", thumbnail: "", instructions: "", ingredients: [])
    var mealId = ""
    var networkManager = NetworkManager()
    let child = LoadingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSpinnerView(child)
        textView.endEditing(true)
        tableView.delegate = self
        tableView.dataSource = self
        networkManager.fetchDetails(networkManager.configUrlString(.byID, with: mealId)) { result in
            switch result {
            case .failure(let error):
                debugPrint(error.localizedDescription)
            case .success(let recipe):
                self.recipe = recipe
                DispatchQueue.main.async {
                    self.removeSpinnerView(self.child)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mealId = ""
    }
    
    private func setValues() {
        if let image = recipe.thumbnail.convertToImage() {
            self.thumbnail.image = image
        }
        thumbnail.layer.cornerRadius = 10
        nameLabel.text = recipe.name
        nameLabel.adjustsFontSizeToFitWidth = true
        textView.text = recipe.instructions
        tableView.reloadData()
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
            cell.configCell(with: recipe.ingredients[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension DetailViewController {
    func createSpinnerView(_ vc: UIViewController) {
        addChild(vc)
        vc.view.frame = view.frame
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func removeSpinnerView(_ vc: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            self.setValues()
        }
    }
}
