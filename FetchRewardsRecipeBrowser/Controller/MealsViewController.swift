//
//  MealsViewController.swift
//  FetchRewardsRecipeBrowser
//
//  Created by Rick Martinez on 3/9/22.
//

import UIKit

class MealsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var meals: [Meal] = []
    var category: String = ""
    var networkManager = NetworkManager()
    var selectedId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        networkManager.fetchMeals(networkManager.configURL(.byMealsInCategory, with: category)) { result in
            switch result {
            case .failure(let error):
                debugPrint(error.localizedDescription)
            case .success(let meals):
                self.meals = meals
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

}

extension MealsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mealsCell", for: indexPath) as? MealsCell {
            cell.configCell(meals[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedId = meals[indexPath.row].id
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? DetailViewController {
            destVC.selectedId = selectedId
        }
    }
    
}
