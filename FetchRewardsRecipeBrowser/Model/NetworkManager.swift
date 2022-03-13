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
    var details = [Details]()
    var recipe: Recipe?
    
    private let BASE_URL = "https://www.themealdb.com/api/json/v1/"
    private let API_KEY = "1"
    
    enum Endpoint: String {
        case byCategory = "/categories.php"
        case byMealsInCategory = "/filter.php?c="
        case byID = "/lookup.php?i="
    }
    
    func configUrlString(_ endpoint: Endpoint, with string: String? = nil) -> String {
        let url = "\(BASE_URL)\(API_KEY)\(endpoint.rawValue)"
        return string == nil ? url : "\(url)\(string!)"
    }
    
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> ()) {
        guard let url = URL(string: configUrlString(.byCategory)) else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                debugPrint(error.debugDescription)
                return
            }
            
            let decoder = JSONDecoder()
            
            if let safeData = data {
                var categories: [Category] = []
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
    
    func fetchMeals(_ string: String, completion: @escaping (Result<[Meal], Error>) -> ()) {
        guard let url = URL(string: string) else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                debugPrint(error.debugDescription)
                return
            }
            
            let decoder = JSONDecoder()
            
            if let safeData = data {
                var meals: [Meal] = []
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
    
    mutating func fetchDetails(_ string: String, completion: @escaping (Result<Recipe, Error>) -> ()) {
        guard let url = URL(string: string) else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard error == nil else {
                debugPrint(error.debugDescription)
                return
            }
            let decoder = JSONDecoder()
            
            if let safeData = data {
                do {
                    let decodedData = try decoder.decode(Details.self, from: safeData)
                    let recipe = createRecipe(with: decodedData)
                    completion(.success(recipe))
                } catch {
                    completion(.failure(error))
                    
                }
            }
        }
        task.resume()
    }
    
    func createRecipe(with details: Details) -> Recipe {
        let removedNils = details.details[0].filter {$0.value != nil || $0.value != ""}
        let ingredients = removedNils.keys.filter {$0.contains("ingredient")}
        let measurements = removedNils.keys.filter { $0.contains("measure")}
        
        if let thumb = details.details[0]["strMealThumb"]!,
           let instructions = details.details[0]["strInstructions"]! {
            let recipe = Recipe(thumbnail: thumb , instructions: instructions, ingredients: ingredients.sorted(by: {$0 < $1}), measurements: measurements.sorted(by: {$0 < $1}))
            return recipe
        } else {
            return Recipe(thumbnail: "", instructions: "", ingredients: [], measurements: [])
        }
        
//        let ingredients = values.filter {$0.key.contains("ingredient")}
//        let measurements = values.filter {$0.key.contains("measure")}
    }
    
    
}
