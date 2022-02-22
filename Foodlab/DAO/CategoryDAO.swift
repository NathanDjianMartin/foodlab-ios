//
//  CategoryDAO.swift
//  Foodlab
//
//  Created by m1 on 18/02/2022.
//

import Foundation

enum CategoryType : String {
    case ingredient = "ingredient-category"
    case allergen = "allergen-category"
    case recipe = "recipe-category"
}

struct CategoryDAO {
    
    //TODO: mettre un singleton? Bonne pratique?
    
    static var stringUrl = "http://localhost:3000/"
    
    // Ingredient
    static func getAllIngredientCategories() async -> [Category]? {
        return await getAllCategories(type: CategoryType.ingredient )
    }
    
    static func getIngredientCategoriesById(id: Int) async -> Result<Category, Error> {
        return await getCategoryById(type: CategoryType.ingredient, id: id)
    }
    
    // Allergen
    static func getAllAllergenCategories() async -> [Category]? {
        return await getAllCategories(type: CategoryType.allergen )
    }
    
    static func getAllergenCategoriesById(id: Int) async -> Result<Category, Error> {
        return await getCategoryById(type: CategoryType.allergen, id: id)
    }
    
    static func getAllCategories(type: CategoryType) async -> [Category]? {
            do {
                
                // faire la requête vers le backend
                guard let url = URL(string: stringUrl + "\(type.rawValue)")
                else { return nil }
                let (data, _) = try await URLSession.shared.data(from: url)
                
                
                // decoder le JSON avec la fonction présente dans JSONHelper
                guard let decoded: [CategoryDTO] = JSONHelper.decode(data: data)
                else { return nil }
                
                // dans une boucle transformer chaque UserDTO en model User
                var categories: [Category] = []
                for categoryDTO in decoded {
                    categories.append( getCategoryFromCategoryDTO(categoryDTO: categoryDTO) )
                }
                
                // retourner une liste de User
                return categories
                
            } catch {
                print("Error while fetching categories from backend: \(error)")
                return nil
            }
        }
    
    static func getCategoryById(type: CategoryType, id: Int) async -> Result<Category, Error> {
            do {
                // TODO: utiliser fonction de l'extension URLSession
                
                // faire la requête vers le backend
                print(stringUrl + "\(type.rawValue)/\(id)")
                guard let url = URL(string: stringUrl + "\(type.rawValue)/\(id)")
                else { return .failure(NetworkError.URLError("problem url")) }
                let (data, _) = try await URLSession.shared.data(from: url)
                
                
                // decoder le JSON avec la fonction présente dans JSONHelper
                print(data)
                guard let categoryDTO: CategoryDTO = JSONHelper.decode(data: data)
                else { return .failure(NetworkError.decodedError("Error when decoding data")) }
                
                // retourner une liste de User
                return .success(getCategoryFromCategoryDTO(categoryDTO: categoryDTO))
                
            } catch {
                print("Error while fetching ingredient from backend: \(error)")
                return .failure(NetworkError.URLError("cest pas url \(stringUrl) \(type.rawValue)/\(id)"))
            }
        }

    
    static func getCategoryFromCategoryDTO(categoryDTO : CategoryDTO) -> Category {
        //TODO : gérer catégorie ingrédient et allergen
        let category = Category(
            id: categoryDTO.id,
            name: categoryDTO.name
        )
        return category
    }
    
    
}
