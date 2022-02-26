//
//  IngredientWithinStepDAO.swift
//  Foodlab
//
//  Created by m1 on 26/02/2022.
//

import Foundation

struct IngredientWithinStepDAO {
    
    static var stringUrl = "http://localhost:3000/"
    
    //TODO: get all ingredient in simple step
    //TODO: get all ingredient in recipe
    //TODO: add ingredient in simple step
    //TODO: delete ingredient in simple step
    /*
    static func getAllIngredientsWithinStep(id: Int) async -> Result<[Ingredient: Double], Error> {
        // récupère toutes les étapes présentent dans une recipe exécution ainsi que le numéro qui lui ai associé
        do {
            let decoded : [StepWithinRecipeExecutionDTO] = try await URLSession.shared.get(from: stringUrl + "recipe-execution/all-steps\(id)")
            
            var steps: [(Int,Step)] = []
            for stepWithinRecipeExecutionDTO in decoded {
                switch await StepDAO.getStepById(id: stepWithinRecipeExecutionDTO.stepId) {
                case .failure(let error):
                    return .failure(error)
                case .success(let step):
                    guard let number = stepWithinRecipeExecutionDTO.number else {
                        return .failure(UndefinedError.error("Erro while creating step within recipe execution : number is nul"))
                    }
                    steps.append((number, step ))
                }
            }
            
            // retourner une liste de User
            return .success(steps)
            
        } catch {
            return .failure(error)
        }
    }
    
    static func addStepWithinRecipeExecution(stepId: Int, recipeExecutionId: Int) async -> Result<Bool, Error> {
        do {
            let stepWithinRecipeExecutionDTO = StepWithinRecipeExecutionDTO(recipeExecutionId: recipeExecutionId, stepId: stepId)
            
            let stepDTOresult : StepWithinRecipeExecutionDTO = try await URLSession.shared.create(from: stringUrl+"step-within-recipe-execution", object: stepWithinRecipeExecutionDTO)
            return .success(true)
        }catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
        
       */
    }
  
