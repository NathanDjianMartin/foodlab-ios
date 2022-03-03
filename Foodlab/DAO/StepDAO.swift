import Foundation

class StepDAO {
    
    static var stringUrl = "http://51.75.248.77:3000/"
    
    static func getAllProgressions() async -> Result<[Step], Error> {
        // retourne toutes les progressions mais avec juste les titres
        do {
            let decoded : [StepDTO] = try await URLSession.shared.get(from: stringUrl + "recipe-execution/progressions")
            
            var steps: [Step] = []
            for stepDTO in decoded {
                steps.append(getStepMinimumInformationFromStepDTO(stepDTO: stepDTO))
            }
            
            return .success(steps)
            
        } catch {
            print("Error while fetching ingredients from backend: \(error)")
            return .failure(error)
        }
    }
    
    static func getStepById(id: Int) async -> Result<Step, Error> {
        do {
            
            let stepDTO : StepDTO = try await URLSession.shared.get(from: stringUrl + "recipe-execution/\(id)")
            
            return await getStepFromStepDTO(stepDTO: stepDTO)
            
        } catch {
            print("Error while fetching step from backend: \(error)")
            return .failure(error)
        }
    }
    
    static func updateStep(step: Step) async -> Result<Bool, Error> {
        do {
            let stepDTO = try getStepDTOFromStep(step: step)
            
            // TODO: verifier id
            // update informations général de l'étape (titre, description et duration)
            let isUpdated = try await URLSession.shared.update(from: stringUrl+"recipe-execution/\(step.id!)", object: stepDTO)
            
            // TODO: update ingredient in step (supprimer tout les ingredients puis les rajouter : à faire dans ingredientWithinStepDAO)
            return .success(isUpdated)
        }catch {
            // on propage l'erreur transmise par la fonctionx post
            return .failure(error)
        }
        
    }
    
    static func createStep(step: Step) async -> Result<Step, Error> {
        do {
            let stepDTO = try getStepDTOFromStep(step: step)
            
            //TODO: verifier id
            // créer l'étapes avec ses informations générales
            let stepDTOresult : StepDTO = try await URLSession.shared.create(from: stringUrl+"recipe-execution", object: stepDTO)
            
            // on vérifie s'il s'agit d'une simpleStep
            if let simpleStep = step as? SimpleStep {
                
                // si oui, on ajoute tout les ingredients à l'étape
                guard let stepId = stepDTOresult.id else { // pour cela il faut récupérer l'id de la step que l'on vient de créer
                    // TODO: créer une nouvelle erreur pour les id manquant
                    return .failure(UndefinedError.error("Missing id"))
                }
                if let ingredients = simpleStep.ingredients {
                    let _ = await IngredientWithinStepDAO.addIngredientsInSimpleStep(stepId: stepId, ingredients: ingredients)
                }
            }
            
            return await getStepFromStepDTO(stepDTO: stepDTOresult)
        } catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
        
    }
    
    static func getStepMinimumInformationFromStepDTO(stepDTO: StepDTO) -> Step {
        return Step(id: stepDTO.id, title: stepDTO.stepTitle)
    }
    
    static func getStepDTOFromStep(step: Step) throws -> StepDTO {
        
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
            // on vérifie quand même les attribut comme ils sont optionnels initialement
            guard let description = stepDTO.stepDescription else {
                //TODO: gerer erreur même si il est pas censé y en avoir puisque controle dans le back
                return .failure(UndefinedError.error("Error while creating step from StepDTO"))
            }
            guard let duration = stepDTO.duration else {
                return .failure(UndefinedError.error("Error while creating step from StepDTO"))
            }
            step = SimpleStep(id: stepDTO.id, title: stepDTO.stepTitle, stepDescription: description, duration: duration)
            // on recupere la liste des ingredients
            guard let stepId = step.id else {
                // TODO: créer une nouvelle erreur pour les id manquant
                return .failure(UndefinedError.error("Missing id"))
            }
            if let simpleStep = step as? SimpleStep {
                switch await IngredientWithinStepDAO.getAllIngredientsWithinStep(id: stepId) {
                case .failure(let error):
                    return .failure(error)
                case .success(let ingredients):
                    simpleStep.ingredients = ingredients
                }
            }
        } else {
            // il s'agit d'une recipe execution qui a seulement des étapes en plus (qui sont optionnelles)
            //step = RecipeExecution(id: stepDTO.id, title: stepDTO.stepTitle)
            guard let recipeExecutionId = stepDTO.id else {
                return .failure(RecipeExecutionDAOError.noId(stepDTO.stepTitle))
            }
            switch await RecipeExecutionDAO.shared.getRecipeExecutionById(recipeExecutionId) {
            case .success(let recipeExecution):
                step = recipeExecution
            case .failure(let error):
                return .failure(error)
            }
        }
        
        return .success(step)
    }
    
    
}
