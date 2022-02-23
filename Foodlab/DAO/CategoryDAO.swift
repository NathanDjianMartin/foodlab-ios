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
    static func getAllIngredientCategories() async -> Result<[Category], Error> {
        return await getAllCategories(type: CategoryType.ingredient )
    }
    
    static func getIngredientCategoriesById(id: Int) async -> Result<Category, Error> {
        return await getCategoryById(type: CategoryType.ingredient, id: id)
    }
    
    // Allergen
    static func getAllAllergenCategories() async -> Result<[Category], Error> {
        return await getAllCategories(type: CategoryType.allergen )
    }
    
    static func getAllergenCategoriesById(id: Int) async -> Result<Category, Error> {
        return await getCategoryById(type: CategoryType.allergen, id: id)
    }
    
    static func getAllCategories(type: CategoryType) async -> Result<[Category], Error> {
            do {
                // recupere tout les ingredients de la base de donnee et les transforment en IngredientDTO
                let decoded : [CategoryDTO] = try await URLSession.shared.getJSON(from: stringUrl + "\(type.rawValue)")
                
                // dans une boucle transformer chaque UserDTO en model User
                var categories: [Category] = []
                for categoryDTO in decoded {
                    categories.append(getCategoryFromCategoryDTO(categoryDTO: categoryDTO))
                }
                
                // retourner une liste de User
                return .success(categories)
                
            } catch {
                return .failure(error)
            }
        }
    
    static func getCategoryById(type: CategoryType, id: Int) async -> Result<Category, Error> {
            do {
                // recupere tout les ingredients de la base de donnee et les transforment en IngredientDTO
                let decoded : CategoryDTO = try await URLSession.shared.getJSON(from: stringUrl + "\(type.rawValue)/\(id)")
        
                // retourne Result avec Category ou Error
                return .success(getCategoryFromCategoryDTO(categoryDTO: decoded))
                
            } catch {
                print("Error while fetching ingredient from backend: \(error)")
                return .failure(error)
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
