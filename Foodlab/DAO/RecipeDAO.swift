import Foundation

enum RecipeDAOError: Error, CustomStringConvertible {
    case noRecipeId(String)
    case noRecipeExecutionId(String, Int)
    
    public var description: String {
        switch self {
        case .noRecipeId(let recipeTitle):
            return "No recipe id was found in the RecipeDTO named: \(recipeTitle)"
        case .noRecipeExecutionId(let recipeTitle, let recipeId):
            return "No recipe execution id was found in the RecipeDTO named: \(recipeTitle) (\(recipeId))"
        }
    }
}

class RecipeDAO {
    
    // MARK: singleton conformance
    
    static var shared: RecipeDAO = {
        return RecipeDAO()
    }()
    
    var stringUrl = "http://localhost:3000/"
    
    private init() {}
    
    
    // MARK: -
    // MARK: functions
    
    func getRecipeById(_ id: Int) async -> Result<Recipe, Error> {
        do {
            let url = stringUrl + "recipe/\(id)"
            let recipeDTO: RecipeDTO = try await URLSession.shared.get(from: url)
            return await getRecipeFromDTO(recipeDTO)
        } catch {
            return .failure(error)
        }
    }
    
    /**
     Gets a Recipe from a given RecipeDTO
     - parameter dto: the RecipeDTO which will be used to get the associated Recipe
     - returns: a Recipe in case of succes; an Error otherwise
     */
    private func getRecipeFromDTO(_ dto: RecipeDTO) async -> Result<Recipe, Error> {
        guard let recipeId = dto.id else {
            return .failure(RecipeDAOError.noRecipeId(dto.name))
        }
        guard let executionId = dto.recipeExecutionId else {
            return .failure(RecipeDAOError.noRecipeExecutionId(dto.name, recipeId))
        }
        
        let category: Category
        switch await CategoryDAO.getCategoryById(type: .recipe, id: dto.recipeCategoryId) {
        case .success(let recipeCategory):
            category = recipeCategory
        case .failure(let error):
            return .failure(error)
        }
        
        let costData: CostData
        switch await CostDataDAO.getCostData(id: dto.costDataId) {
        case .success(let recipeCostData):
            costData = recipeCostData
        case .failure(let error):
            return .failure(error)
        }
        
        let execution: RecipeExecution
        switch await RecipeExecutionDAO.shared.getRecipeExecutionById(executionId) {
        case .success(let recipeExecution):
            execution = recipeExecution
        case .failure(let error):
            return .failure(error)
        }
        
        return .success(Recipe(id: dto.id, title: dto.name, author: dto.author, guestsNumber: dto.guestsNumber, recipeCategory: category, costData: costData, execution: execution))
    }
}
