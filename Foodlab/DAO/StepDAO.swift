//
//  RecipeExecutionDAO.swift
//  Foodlab
//
//  Created by m1 on 26/02/2022.
//

import Foundation

class StepDAO {
    
    static var stringUrl = "http://51.75.248.77:3000/"
    
    static func getAllProgressions() async -> Result<[Step], Error> {
        do {
            // recupere tout les ingredients de la base de donnee et les transforment en IngredientDTO
            let decoded : [StepDTO] = try await URLSession.shared.get(from: stringUrl + "recipe-execution/progressions")
            
            // dans une boucle transformer chaque IngredientDTO en model Ingredient
            var steps: [Step] = []
            for stepDTO in decoded {
                steps.append(getStepMinimumInformationFromStepDTO(stepDTO: stepDTO))
            }
            
            // retourner une liste d'Ingredient
            return .success(steps)
            
        } catch {
            print("Error while fetching ingredients from backend: \(error)")
            return .failure(error)
        }
    }
    
    static func getStepById(id: Int) async -> Result<Step, Error> {
        do {
            
            // decoder le JSON avec la fonction présente dans JSONHelper
            let stepDTO : StepDTO = try await URLSession.shared.get(from: stringUrl + "recipe-execution/\(id)")
            
            // retourner un Result avec ingredient ou error
            return await getStepFromStepDTO(stepDTO: stepDTO)
            
        } catch {
            print("Error while fetching step from backend: \(error)")
            return .failure(error)
        }
    }
    
    static func updateStep(step: Step) async -> Result<Bool, Error> {
        do {
            let stepDTO = try getSteptDTOFromStep(step: step)

            // TODO: verifier id
            let isUpdated = try await URLSession.shared.update(from: stringUrl+"recipe-execution/\(step.id!)", object: stepDTO)
            return .success(isUpdated)
        }catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
        
    }
    
    static func createStep(step: Step) async -> Result<Step, Error> {
        do {
            
            let stepDTO = try getSteptDTOFromStep(step: step)

            //TODO: verifier id
            let stepDTOresult : StepDTO = try await URLSession.shared.create(from: stringUrl+"recipe-execution", object: stepDTO)
            return await getStepFromStepDTO(stepDTO: stepDTOresult)
        }catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
        
    }
    
    static func getStepMinimumInformationFromStepDTO(stepDTO: StepDTO) -> Step {
        return Step(id: stepDTO.id, title: stepDTO.stepTitle)
    }
    
    static func getSteptDTOFromStep(step: Step) throws -> StepDTO {
        
        var stepDTO: StepDTO
        
        if let simpleStep = step as? SimpleStep  {
            stepDTO = StepDTO(id: simpleStep.id, isStep: true, stepTitle: simpleStep.title, stepDescription: simpleStep.description, duration: simpleStep.duration)
        }
        if let recipeExecution = step as? RecipeExecution {
            stepDTO = StepDTO(id: recipeExecution.id, isStep: false, stepTitle: recipeExecution.title)
        } else {
            throw UndefinedError.error("Error with creation stepDTO from step")
        }
        return stepDTO
    }
    
    static func getStepFromStepDTO(stepDTO : StepDTO) async -> Result<Step, Error> {

        let step: Step
        
        if stepDTO.isStep {
            // s'il s'agit d'une étape alors elle a une description, une durée...
            // on vérifie quand même les attribut comme ils s'ont optionel initialement
            guard let description = stepDTO.stepDescription else {
                //TODO: gerer erreur même si il est pas censé y en avoir puisque controle dans le back
                return .failure(UndefinedError.error("Error while creating step from StepDTO"))
            }
            guard let duratiion = stepDTO.duration else {
                return .failure(UndefinedError.error("Error while creating step from StepDTO"))
            }
            step = SimpleStep(id: stepDTO.id, title: stepDTO.stepTitle, stepDescription: description, duration: duratiion)
            // TODO: recuperer la liste des ingredients
        } else {
            // il s'agit d'une recipe execution qui a seulement des étapes en plus (qui sont optionnelles)
            step = RecipeExecution(id: stepDTO.id, title: stepDTO.stepTitle)
            // TODO: récupérer les étapes qu'elle contient
            // Il faut aller faire une requête sur le back est récupérer les tables de jointure stepWithinRecipeExecution
        }
        
        return .success(step)
    }
    
    
}
