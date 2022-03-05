import Foundation

struct StepWithinRecipeExecutionDAO {
    // MARK: singleton conformance
    
    static var shared: StepWithinRecipeExecutionDAO = {
        return StepWithinRecipeExecutionDAO()
    }()
    
    private init() {}
    
    func getAllStepsWithinRecipeExecution(id: Int) async -> Result<[(Int,Step)], Error> {
        // récupère toutes les étapes présentent dans une recipe exécution ainsi que le numéro qui lui est associé
        do {
            let url = FoodlabApp.apiUrl + "recipe-execution/all-steps/\(id)"
            let decoded: [StepWithinRecipeExecutionDTO] = try await URLSession.shared.get(from: url)
            
            var steps: [(Int, Step)] = []
            for stepWithinRecipeExecutionDTO in decoded {
                switch await StepDAO.shared.getStepById(id: stepWithinRecipeExecutionDTO.stepId) {
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
    
    func addStepWithinRecipeExecution(stepId: Int, recipeExecutionId: Int) async -> Result<Bool, Error> {
        do {
            let stepWithinRecipeExecutionDTO = StepWithinRecipeExecutionDTO(recipeExecutionId: recipeExecutionId, stepId: stepId)
            
            let _: StepWithinRecipeExecutionDTO = try await URLSession.shared.create(from: FoodlabApp.apiUrl + "step-within-recipe-execution", object: stepWithinRecipeExecutionDTO)
            return .success(true)
        }catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
        
        
    }
    
    func deleteStepWithinRecipeExecution(id: Int) async -> Result<Bool, Error> {
        do {
            print(id)
            let isDeleted : Bool = try await URLSession.shared.delete(from: FoodlabApp.apiUrl + "recipe-execution/remove-step-within-recipe-execution/\(id)")
            return .success(isDeleted)
        }catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
        
        
    }
    
    
}
