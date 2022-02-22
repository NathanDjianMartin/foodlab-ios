//
//  IngredientDAO.swift
//  Foodlab
//
//  Created by m1 on 17/02/2022.
//

import Foundation

struct IngredientDAO {
    //TODO: mettre un singleton? Bonne pratique?
    
    /*
     Se charge de créer à partir de la base de données un ingrédient, de récupérer la liste des ingrédients ...
     Interface qui fait le lien avec la base de données
     Va implémenter des fonctions :
        - get(),
        - getAll(),
        - create(),
        - update(),
        - delete() ...
     */
    
    static var stringUrl = "http://51.75.248.77:3000/"
    
    static func getAllIngredients() async -> [Ingredient]? {
            do {
                // recupere tout les ingredients de la base de donnee et les transforment en IngredientDTO
                let decoded : [IngredientDTO] = try await URLSession.shared.getJSON(from: stringUrl + "ingredient")
                
                // dans une boucle transformer chaque IngredientDTO en model Ingredient
                var ingredients: [Ingredient] = []
                for ingredientDTO in decoded {
                    ingredients.append(await getIngredientFromIngredientDTO(ingredientDTO: ingredientDTO) )
                }
                
                // retourner une liste de Ingredient
                return ingredients
                
            } catch {
                print("Error while fetching ingredients from backend: \(error)")
                return nil
            }
        }
    
    static func getIngredientById(id: Int) async -> Ingredient? {
            do {
    
                // decoder le JSON avec la fonction présente dans JSONHelper
                let ingredientDTO : IngredientDTO = try await URLSession.shared.getJSON(from: stringUrl + "ingredient/\(id)")
                
                // retourner une liste de User
                return await getIngredientFromIngredientDTO(ingredientDTO: ingredientDTO)
                
            } catch {
                print("Error while fetching ingredient from backend: \(error)")
                return nil
            }
        }

    static func updateIngredient(ingredient: Ingredient) async -> Ingredient? {
        let ingredientDTO = getIngredientDTOFromIngredient(ingredient: ingredient)
        do {
            guard let ingredientDTOresult : IngredientDTO = try await URLSession.shared.postJSON(from: stringUrl+"ingredient/\(ingredient.id)", object: ingredientDTO) else {
            return nil
        }
        return await getIngredientFromIngredientDTO(ingredientDTO: ingredientDTOresult)
        }catch {
            print("erreur")
            return nil
        }
        
    }
    
    static func getIngredientDTOFromIngredient(ingredient: Ingredient) -> IngredientDTO {
        //TODO: on suppose qu'il s'agit d'une modification pour l'instant donc il y a déjà les categorie id juste pour faire un premier test
        return IngredientDTO(id: ingredient.id, name: ingredient.name, unitaryPrice: String(ingredient.unitaryPrice), unit: ingredient.unit, stockQuantity: String(ingredient.stockQuantity), ingredientCategoryId: ingredient.ingredientCategory.id!, allergenCategoryId: ingredient.allergenCategory!.id!)
    }
    
    static func getIngredientFromIngredientDTO(ingredientDTO : IngredientDTO) async -> Ingredient {
        //TODO : gérer catégorie ingrédient et allergen
        let ingredient = Ingredient(
            id: ingredientDTO.id,
            name: ingredientDTO.name,
            unit: ingredientDTO.unit,
            unitaryPrice: 0.0,
            stockQuantity: 0.0,
            ingredientCategory: Category(id: 1, name: "test"),
            allergenCategory: Category(id: 2, name: "test")
        )
        
        if let price = Double(ingredientDTO.unitaryPrice) {
            ingredient.unitaryPrice = price
        }
        //TODO: lever exception si problème de conversion
        if let stockQuantity = Double(ingredientDTO.stockQuantity) {
            ingredient.stockQuantity = stockQuantity
        }
        if let ingredientCategory = await CategoryDAO.getIngredientCategoriesById(id: ingredientDTO.ingredientCategoryId) {
            ingredient.ingredientCategory = ingredientCategory
        }
        return ingredient
    }
    
    
}
