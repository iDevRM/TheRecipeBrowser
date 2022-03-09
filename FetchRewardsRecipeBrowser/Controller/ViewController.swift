//
//  ViewController.swift
//  FetchRewardsRecipeBrowser
//
//  Created by Rick Martinez on 3/8/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let networkManager = NetworkManager()
    var categories: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        networkManager.fetchRequest(networkManager.configURL(.byCategory), completion: <#T##(Result<[Category], Error>) -> ()#>)
    }
    


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "rightSideCell", for: indexPath) as? RightSideCell {
                cell.configCell(with: categories[indexPath.row])
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "leftSideCell", for: indexPath) as? LeftSideCell {
                cell.configCell(with: categories[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
}



