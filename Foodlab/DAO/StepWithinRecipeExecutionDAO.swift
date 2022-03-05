import Foundation

struct StepWithinRecipeExecutionDAO {
    
    static var stringUrl = "http://localhost:3000/"
    
    static func getAllStepsWithinRecipeExecution(id: Int) async -> Result<[(Int,Step)], Error> {
        // récupère toutes les étapes présentent dans une recipe exécution ainsi que le numéro qui lui est associé
        do {
            let url = stringUrl + "recipe-execution/all-steps/\(id)"
            let decoded: [StepWithinRecipeExecutionDTO] = try await URLSession.shared.get(from: url)
            
            var steps: [(Int, Step)] = []
            for stepWithinRecipeExecutionDTO in decoded {
                switch await StepDAO.getStepById(id: stepWithinRecipeExecutionDTO.stepId) {
                case .failure(let error):
                    return .failure(error)
                case .success(let step):
                    guard let number = stepWithinRecipeExecutionDTO.number else {
                        return .failure(UndefinedError.error("Error while creating step within recipe execution: number is nil"))
                    }
                    step.stepWithinRecipeExecutionId = stepWithinRecipeExecutionDTO.id
                    steps.append((number, step ))
                }
            }
            
            return .success(steps)
            
        } catch {
            return .failure(error)
        }
    }
    
    static func addStepWithinRecipeExecution(stepId: Int, recipeExecutionId: Int) async -> Result<Bool, Error> {
        do {
            let stepWithinRecipeExecutionDTO = StepWithinRecipeExecutionDTO(recipeExecutionId: recipeExecutionId, stepId: stepId)
            
            let stepDTOresult : StepWithinRecipeExecutionDTO = try await URLSession.shared.create(from: stringUrl + "step-within-recipe-execution", object: stepWithinRecipeExecutionDTO)
            return .success(true)
        }catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
        
        
    }
    
    
}
