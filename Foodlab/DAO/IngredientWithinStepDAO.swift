//
//  IngredientWithinStepDAO.swift
//  Foodlab
//
//  Created by m1 on 26/02/2022.
//

import Foundation

struct IngredientWithinStepDAO {
    // MARK: singleton conformance
    
    static var shared: IngredientWithinStepDAO = {
        return IngredientWithinStepDAO()
    }()
    
    private init() {}

    //TODO: delete ingredient in simple step
    
    func getAllIngredientsWithinStep(id: Int) async -> Result<[Ingredient: Double], Error> {
        // récupère tout les ingredients présent dans une simple step ainsi que la quantite associée
        do {
            let decoded : [IngredientWithinStepDTO] = try await URLSession.shared.get(from: FoodlabApp.apiUrl + "recipe-execution/all-ingredients-within-a-step-in-simple-step/\(id)")
         
            return await getIngredientsDicoFromIngredientDTOList(ingredientsDTO: decoded)
            
        } catch {
            return .failure(error)
        }
    }
    
    func getAllIngredientsWithinRecipe(recipeId: Int) async -> Result<[Ingredient: Double], Error> {
        // TODO: faire la fonction dans le bac, on ne s'en était pas servi comme ça pour le web donc pas de route correspondant à ma requête pour l'instant
        // récupère tout les ingredients présent dans une recette ainsi que la quantite associée
        do {
            let decoded : [IngredientWithinStepDTO] = try await URLSession.shared.get(from: FoodlabApp.apiUrl + "/recipe/ingredients-in-recipe/\(recipeId)")
         
            return await getIngredientsDicoFromIngredientDTOList(ingredientsDTO: decoded)
            
        } catch {
            return .failure(error)
        }
    }
    
    func getIngredientsDicoFromIngredientDTOList(ingredientsDTO: [IngredientWithinStepDTO]) async -> Result<[Ingredient: Double], Error> {
        var ingredientsWithinStep: [Ingredient: Double] = [:]
        for ingredientWithinStepDTO in ingredientsDTO {
            
            // on recupere l'ingredient
            switch await IngredientDAO.shared.getIngredientById(id: ingredientWithinStepDTO.ingredientId){
            case .failure(let error):
                return .failure(error)
            case .success(let ingredient):
                let quantity: Double
                switch ingredientWithinStepDTO.quantity {
                    
                // on a pu recuperer l'ingredient, on ajoute alors la quantite associé dans le dictionnaire
                case .post(let double):
                    quantity = double
                case .get(let string):
                    guard let double = Double(string) else {
                        return .failure(ConversionError.stringToDouble)
                    }
                    quantity = double
                }
                ingredientsWithinStep[ingredient] = quantity
            }
        }
        return .success(ingredientsWithinStep)
    }
    
    func addIngredientsInSimpleStep(stepId: Int, ingredients: [Ingredient:Double]) async -> Result<Bool, Error> {
        // prend un dictionnaire d'ingredients et de sa quantité, l'id d'une étape et ajoute chaque ingredients dans l'étape c a d créer une ligne dans la table ingredientInStep
        do {
            for (ingredient,quantity) in ingredients {
                guard let ingredientID = ingredient.id else {
                    return .failure(UndefinedError.error("Missing id"))
                }
                let ingredientWithinStepDTO = IngredientWithinStepDTO(ingredientId: ingredientID, stepId: stepId, quantity: .post(quantity))
                let ingredientDTOresult : IngredientWithinStepDTO = try await URLSession.shared.create(from: FoodlabApp.apiUrl + "ingredient-within-step", object: ingredientWithinStepDTO)
            }
            
            return .success(true)
        }catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
    
    }
}
