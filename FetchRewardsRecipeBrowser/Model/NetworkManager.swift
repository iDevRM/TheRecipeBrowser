//
//  NetworkManager.swift
//  FetchRewardsRecipeBrowser
//
//  Created by Rick Martinez on 3/8/22.
//

import Foundation

struct NetworkManager {
    
    // put these into user defaults
    var categories = [Category]()
    var meals = [Meal]()
    var details = [Recipe]()
    
    private let BASE_URL = "https://www.themealdb.com/api/json/v1/"
    private let API_KEY = "1"
    
    enum Endpoint: String {
        case byCategory = "/categories.php"
        case byMealsInCategory = "/filter.php?c="
        case byID = "/lookup.php?i="
    }
    
    func configURL(_ endpoint: Endpoint, with string: String? = nil) -> URL? {
        if string != nil {
            if let url = URL(string: "\(BASE_URL)\(API_KEY)\(endpoint.rawValue)\(string!)") {
                return url
            }
        } else {
            if let url = URL(string: "\(BASE_URL)\(API_KEY)\(endpoint.rawValue)") {
                return url
            }
        }
        return nil
    }
    
    func fetchCategories(_ url: URL?, completion: @escaping (Result<[Category], Error>) -> ()) {
        guard let safeURL = url else { return }
        var categories: [Category] = []
        
        let request = URLRequest(url: safeURL)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                debugPrint(error.debugDescription)
                return
            }
            
            let decoder = JSONDecoder()
            
            if let safeData = data {
                do {
                    let decodedData = try decoder.decode(Categories.self, from: safeData)
                    categories = decodedData.categories
                    completion(.success(categories))
                    categories.removeAll()
                } catch {
                    completion(.failure(error))
                    debugPrint(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    func fetchMeals(_ url: URL?, completion: @escaping (Result<[Meal], Error>) -> ()) {
        guard let safeURL = url else { return }
        var meals: [Meal] = []
        
        let request = URLRequest(url: safeURL)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                debugPrint(error.debugDescription)
                return
            }
            
            let decoder = JSONDecoder()
            
            if let safeData = data {
                do {
                    let decodedData = try decoder.decode(Meals.self, from: safeData)
                    meals = decodedData.meals
                    completion(.success(meals))
                    meals.removeAll()
                } catch {
                    completion(.failure(error))
                    debugPrint(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func fetchDetails(_ url: URL?, completion: @escaping (Result<Recipe, Error>) -> ()) {
        guard let safeURL = url else { return }
        var recipe = Recipe(meals: [[:]])
        
        let request = URLRequest(url: safeURL)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                debugPrint(error.debugDescription)
                return
            }
            
            let decoder = JSONDecoder()
            
            if let safeData = data {
                do {
                    let decodedData = try decoder.decode(Recipe.self, from: safeData)
                    print(decodedData.meals)
                    recipe = decodedData
                    completion(.success(recipe))
                } catch {
                    completion(.failure(error))
                    debugPrint(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    
}
