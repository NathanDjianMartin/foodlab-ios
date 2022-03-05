import Foundation

enum RecipeExecutionDAOError: LocalizedError {
    case noIdInDTO(String)
    case noIdInModel(String)
    
    var description: String {
        switch self {
        case .noIdInDTO(let recipeExecutionTitle):
            return "No recipe execution id was found in the RecipeExecutionDTO named \(recipeExecutionTitle)"
        case .noIdInModel(let recipeExecutionTitle):
            return "No recipe execution id was found in the RecipeExecution model named \(recipeExecutionTitle)"
        }
    }
    
    var errorDescription: String? {
        return self.description
    }
}

class RecipeExecutionDAO {
    
    static let shared: RecipeExecutionDAO = {
        return RecipeExecutionDAO()
    }()
    
    var stringUrl = "http://localhost:3000/"
    
    private init() {}
    
    // MARK: -
    // MARK: public functions
    
    func getRecipeExecutionById(_ id: Int) async -> Result<RecipeExecution, Error> {
        do {
            let url = stringUrl + "recipe-execution/\(id)"
            let recipeExecutionDTO: RecipeExecutionDTO = try await URLSession.shared.get(from: url)
            return await getRecipeExecutionFromDTO(recipeExecutionDTO)
        } catch {
            return .failure(error)
        }
    }
    
    func saveRecipeExecution(_ execution: RecipeExecution) async -> Result<RecipeExecution, Error> {
        return await self.updateStepsOrder(execution)
//        guard let executionId = execution.id else {
//            return .failure(RecipeExecutionDAOError.noIdInModel(execution.title))
//        }
//        do {
//            let url = ""
//            let recipeExecutionDTO = getDTOFromRecipeExecution(execution)
//            let done = try await URLSession.shared.update(from: url, object: recipeExecutionDTO)
//            return .success(execution)
//        } catch {
//            return .failure(error)
//        }
    }
    
    func updateStepsOrder(_ execution: RecipeExecution) async -> Result<RecipeExecution, Error> {
        guard let executionId = execution.id else {
            return .failure(RecipeExecutionDAOError.noIdInModel(execution.title))
        }
        
        do {
            // DTOs array construction
            var stepWithinRecipeExecutionDTOs: [StepWithinRecipeExecutionDTO] = []
            for (index, step) in execution.steps.enumerated() {
                guard let stepId = step.id else {
                    return.failure(RecipeExecutionDAOError.noIdInModel("STEP \(step)"))
                }
                let dto = StepWithinRecipeExecutionDTO(id: step.stepWithinRecipeExecutionId, number: index + 1, recipeExecutionId: executionId, stepId: stepId)
                stepWithinRecipeExecutionDTOs.append(dto)
            }
            
            // Perform request on the backend
            let url = stringUrl + "recipe-execution/update-steps-order"
            let _ = try await URLSession.shared.update(from: url, object: stepWithinRecipeExecutionDTOs)
            return .success(execution)
        } catch {
            return.failure(error)
        }
    }
    
    
    // MARK: -
    // MARK: private functions
    
    private func getRecipeExecutionFromDTO(_ dto: RecipeExecutionDTO) async -> Result<RecipeExecution, Error> {
        guard let recipeExecutionId = dto.id else {
            return .failure(RecipeExecutionDAOError.noIdInDTO(dto.stepTitle))
        }
        
        let recipeExecution = RecipeExecution(id: recipeExecutionId, title: dto.stepTitle)
        
        var stepsWithinRecipeExecution: [(Int, Step)]
        switch await StepWithinRecipeExecutionDAO.getAllStepsWithinRecipeExecution(id: recipeExecutionId) {
        case .success(let steps):
            stepsWithinRecipeExecution = steps
        case .failure(let error):
            return .failure(error)
        }
        
        stepsWithinRecipeExecution.sort { step1, step2 in
            return step1.0 <= step2.0
        }
        
        for step in stepsWithinRecipeExecution {
            recipeExecution.addStep(step.1) // adds the actual step without it's associated number
        }
        
        return .success(recipeExecution)
    }
    
    private func getDTOFromRecipeExecution(_ recipeExecution: RecipeExecution) -> RecipeExecutionDTO {
        let recipeExecutionDTO = RecipeExecutionDTO(id: recipeExecution.id, stepTitle: recipeExecution.title)
        return recipeExecutionDTO
    }
}
