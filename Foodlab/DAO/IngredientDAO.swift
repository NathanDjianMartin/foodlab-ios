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
    
    static func getAllIngredients() async -> Result<[Ingredient], Error> {
        do {
            // recupere tout les ingredients de la base de donnee et les transforment en IngredientDTO
            let decoded : [IngredientDTO] = try await URLSession.shared.getJSON(from: stringUrl + "ingredient")
            
            // dans une boucle transformer chaque IngredientDTO en model Ingredient
            var ingredients: [Ingredient] = []
            for ingredientDTO in decoded {
                switch await getIngredientFromIngredientDTO(ingredientDTO: ingredientDTO) {
                case .failure(let error):
                    return .failure(error)
                case .success(let ingredient):
                    ingredients.append(ingredient)
                }
            }
            
            // retourner une liste de Ingredient
            return .success(ingredients)
            
        } catch {
            print("Error while fetching ingredients from backend: \(error)")
            return .failure(NetworkError.URLError("encore une erreur a changer"))
        }
    }
    
    static func getIngredientById(id: Int) async -> Result<Ingredient, Error> {
        do {
            
            // decoder le JSON avec la fonction présente dans JSONHelper
            let ingredientDTO : IngredientDTO = try await URLSession.shared.getJSON(from: stringUrl + "ingredient/\(id)")
            
            // retourner une liste de User
            return await getIngredientFromIngredientDTO(ingredientDTO: ingredientDTO)
            
        } catch {
            print("Error while fetching ingredient from backend: \(error)")
            return .failure(NetworkError.URLError("cest toujours pas la bonne erreur"))
        }
    }
    
    static func updateIngredient(ingredient: Ingredient) async -> Result<Ingredient, Error> {
        let ingredientDTO = getIngredientDTOFromIngredient(ingredient: ingredient)
        do {
            //TODO : verifier id
            print(stringUrl+"ingredient/\(ingredient.id!)")
            guard let ingredientDTOresult : IngredientDTO = try await URLSession.shared.postJSON(from: stringUrl+"ingredient/\(ingredient.id!)", object: ingredientDTO) else {
                return .failure(NetworkError.URLError("cest toujours pas la bonne erreur"))
            }
            return await getIngredientFromIngredientDTO(ingredientDTO: ingredientDTOresult)
        }catch {
            print("erreur")
            return .failure(NetworkError.URLError("cest toujours pas la bonne erreur"))        }
        
    }
    
    static func getIngredientDTOFromIngredient(ingredient: Ingredient) -> IngredientDTO {
        //TODO: on suppose qu'il s'agit d'une modification pour l'instant donc il y a déjà les categorie id juste pour faire un premier test
        return IngredientDTO(id: ingredient.id, name: ingredient.name, unit: ingredient.unit, unitaryPrice: .post(ingredient.unitaryPrice), stockQuantity: .post(ingredient.stockQuantity), ingredientCategoryId: ingredient.ingredientCategory.id!, allergenCategoryId: ingredient.allergenCategory!.id!)
    }
    
    static func getIngredientFromIngredientDTO(ingredientDTO : IngredientDTO) async -> Result<Ingredient, Error> {
        // manage unitary price
        let unitaryPrice: Double
        switch ingredientDTO.unitaryPrice {
        case .post(let double):
            unitaryPrice = double
        case .get(let string):
            guard let double = Double(string) else {
                return .failure(NetworkError.URLError("erreur conversion double a changer "))
            }
            unitaryPrice = double
        }
        
        // manage stock quantity
        let stockQuantity: Double
        switch ingredientDTO.stockQuantity {
        case .post(let double):
            stockQuantity = double
        case .get(let string):
            guard let double = Double(string) else {
                return .failure(NetworkError.URLError("erreur conversion double a changer "))
            }
            stockQuantity = double
        }
        
        // manage ingredient category
        let ingredientCategory: Category
        switch await CategoryDAO.getIngredientCategoriesById(id: ingredientDTO.ingredientCategoryId){
        case .failure(let error):
            return .failure(error)
        case .success(let category):
            ingredientCategory = category
        }
        
        // manage ingredient category
        var allergenCategory: Category? = nil
        if let allergen = ingredientDTO.allergenCategoryId {
            switch await CategoryDAO.getAllergenCategoriesById(id: allergen){
            case .failure(let error):
                return .failure(error)
            case .success(let category):
                allergenCategory = category
            }
        }
        
        let ingredient = Ingredient(
            id: ingredientDTO.id,
            name: ingredientDTO.name,
            unit: ingredientDTO.unit,
            unitaryPrice: unitaryPrice,
            stockQuantity: stockQuantity,
            ingredientCategory: ingredientCategory,
            allergenCategory: allergenCategory
        )
        
        return .success(ingredient)
    }
    
    
}
