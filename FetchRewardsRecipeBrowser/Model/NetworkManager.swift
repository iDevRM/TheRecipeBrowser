//
//  NetworkManager.swift
//  FetchRewardsRecipeBrowser
//
//  Created by Rick Martinez on 3/8/22.
//

import Foundation

struct NetworkManager {
    
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
                    debugPrint(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    private func createRecipe(with details: Details) -> Recipe {
        let cleanDictionary = removeInvalidValues(from: details)
        
        let trueIngredients = createTrueIngredient(with: cleanDictionary)
        
        if let thumb = details.meals[0]["strMealThumb"]!,
           let instructions = details.meals[0]["strInstructions"]!,
           let name = details.meals[0]["strMeal"]! {
            let recipe = Recipe(name: name, thumbnail: thumb, instructions: instructions, ingredients: trueIngredients)
            return recipe
        } else {
            return Recipe(name: "", thumbnail: "", instructions: "", ingredients: [])
        }
    }
    
    private func removeInvalidValues(from details: Details) -> [String : String?] {
        let removedNils = details.meals[0].filter {$0.value != nil}
        let removedEmpties = removedNils.filter  { $0.value! != "" }
        let removedSpaces = removedEmpties.filter { $0.value! != " " }
        return removedSpaces
    }
    
    private func createTrueIngredient(with dictionary: [String: String?]) -> [TrueIngredient] {
        var ingredientArray = [Ingredient]()
        var measurementArray = [Measurement]()
        var trueIngredientArray = [TrueIngredient]()
        
        for (key, value) in dictionary {
            if let safeValue = value {
                if key.contains("Ingredient") {
                    ingredientArray.append(Ingredient(key: key, name: safeValue))
                } else if key.contains("Measure") {
                    measurementArray.append(Measurement(key: key, amount: safeValue))
                }
            }
        }
        
        let sortedIngredients = ingredientArray.sorted {$0.key < $1.key}
        let sortedMeasurements = measurementArray.sorted {$0.key < $1.key}
        
        for (ingredient, measurement) in zip(sortedIngredients,sortedMeasurements) {
            trueIngredientArray.append(TrueIngredient(name: ingredient.name, amount: measurement.amount))
        }
        return trueIngredientArray
    }
}
