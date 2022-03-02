import Foundation

enum RecipeExecutionDAOError: LocalizedError {
    case noId(String)
    
    var description: String {
        switch self {
        case .noId(let recipeExecutionTitle):
            return "No recipe execution id was found in the RecipeExecutionDTO named \(recipeExecutionTitle)"
        }
    }
}

class RecipeExecutionDAO {
    
    static let shared: RecipeExecutionDAO = {
        return RecipeExecutionDAO()
    }()
    
    var stringUrl = "http://localhost:3000/"
    
    private init() {}
    
    func getRecipeExecutionById(_ id: Int) async -> Result<RecipeExecution, Error> {
        do {
            let url = stringUrl + "recipe-execution/\(id)"
            let recipeExecutionDTO: RecipeExecutionDTO = try await URLSession.shared.get(from: url)
            return await getRecipeExecutionFromDTO(recipeExecutionDTO)
        } catch {
            return .failure(error)
        }
    }
    
    private func getRecipeExecutionFromDTO(_ dto: RecipeExecutionDTO) async -> Result<RecipeExecution, Error> {
        guard let recipeExecutionId = dto.id else {
            return .failure(RecipeExecutionDAOError.noId(dto.stepTitle))
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
            recipeExecution.addStep(step.1) // adds the actual step without it's number property
        }
        
        return .success(recipeExecution)
    }
}
