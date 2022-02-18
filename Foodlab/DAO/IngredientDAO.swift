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
                
                // faire la requête vers le backend
                guard let url = URL(string: stringUrl + "ingredient")
                else { return nil }
                let (data, _) = try await URLSession.shared.data(from: url)
                
                
                // decoder le JSON avec la fonction présente dans JSONHelper
                guard let decoded: [IngredientDTO] = JSONHelper.decode([IngredientDTO].self, data: data)
                else { return nil }
                
                // dans une boucle transformer chaque UserDTO en model User
                var ingredients: [Ingredient] = []
                for ingredientDTO in decoded {
                    ingredients.append( getIngredientFromIngredientDTO(ingredientDTO: ingredientDTO) )
                }
                
                // retourner une liste de User
                return ingredients
                
            } catch {
                print("Error while fetching ingredients from backend: \(error)")
                return nil
            }
        }
    
    static func getIngredientById(id: Int) async -> Ingredient? {
            do {
                
                // faire la requête vers le backend
                guard let url = URL(string: stringUrl + "detail+id")
                else { return nil }
                let (data, _) = try await URLSession.shared.data(from: url)
                
                
                // decoder le JSON avec la fonction présente dans JSONHelper
                guard let ingredientDTO: IngredientDTO = JSONHelper.decode(IngredientDTO.self, data: data)
                else { return nil }
                
                // retourner une liste de User
                return getIngredientFromIngredientDTO(ingredientDTO: ingredientDTO)
                
            } catch {
                print("Error while fetching ingredient from backend: \(error)")
                return nil
            }
        }

    
    static func getIngredientFromIngredientDTO(ingredientDTO : IngredientDTO) -> Ingredient {
        //TODO : gérer catégorie ingrédient et allergen
        let ingredient = Ingredient(
            id: ingredientDTO.id,
            name: ingredientDTO.name,
            unit: ingredientDTO.unit,
            unitaryPrice: 0.0,
            stockQuantity:0.0,
            ingredientCategory: "test",
            allergenCategory: "test"
        )
        
        if let price = Double(ingredientDTO.unitaryPrice) {
            ingredient.unitaryPrice = price
        }
        if let stockQuantity = Double(ingredientDTO.stockQuantity) {
            ingredient.stockQuantity = stockQuantity
        }
        return ingredient
    }
    
    
}
