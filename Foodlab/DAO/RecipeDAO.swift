import Foundation

enum RecipeDAOError: LocalizedError {
    // DTO errors
    case noRecipeIdInDTO(String)
    case noRecipeExecutionIdInDTO(String)
    
    // Model errors
    case noRecipeIdInModel(String)
    case noRecipeCategoryIdInModel(String)
    case noCostDataIdInModel(String)
    
    var description: String {
        switch self {
        case .noRecipeIdInDTO(let recipeTitle):
            return "No recipe id was found in the RecipeDTO named: \(recipeTitle)"
        case .noRecipeExecutionIdInDTO(let recipeTitle):
            return "No recipe execution id was found in the RecipeDTO named: \(recipeTitle)"
        case .noRecipeIdInModel(let recipeTitle):
            return "No recipe id was found in the Recipe model named: \(recipeTitle)"
        case .noRecipeCategoryIdInModel(let recipeTitle):
            return "No recipe category id was found in the Recipe model named \(recipeTitle)"
        case .noCostDataIdInModel(let recipeTitle):
            return "No cost data id was found in the Recipe model named \(recipeTitle)"
        }
    }
    
    var errorDescription: String? {
        return self.description
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
    // MARK: public functions
    
    func getRecipeById(_ id: Int) async -> Result<Recipe, Error> {
        do {
            let url = stringUrl + "recipe/\(id)"
            let recipeDTO: RecipeDTO = try await URLSession.shared.get(from: url)
            return await getRecipeFromDTO(recipeDTO)
        } catch {
            return .failure(error)
        }
    }
    
    func getAllRecipes() async -> Result<[Recipe], Error> {
        do {
            let url = stringUrl + "recipe"
            let recipeDTOs: [RecipeDTO] = try await URLSession.shared.get(from: url)
            var recipes: [Recipe] = []
            
            for dto in recipeDTOs {
                switch await self.getRecipeHeaderFromDTO(dto) {
                case .success(let recipe):
                    recipes.append(recipe)
                case .failure(let error):
                    return .failure(error)
                }
            }
            
            return .success(recipes)
        } catch {
            return .failure(error)
        }
    }
    
    /**
     Creates a recipe in the backend given a Recipe model.
     - parameter recipe: the Recipe model that will be used to create the Recipe in the backend
     - returns: the given Recipe with the id property correctly set; an error otherwise
     */
    func createRecipe(recipe: Recipe) async -> Result<Recipe, Error> {
        let emptyExecution: RecipeExecution
        switch await StepDAO.shared.createStep(step: RecipeExecution(title: recipe.title)) {
        case .success(let step):
            guard let execution = step as? RecipeExecution else {
                return .failure(UndefinedError.error("The created empty execution is not of type RecipeExecution"))
            }
            emptyExecution = execution
        case .failure(let error):
            return .failure(error)
        }
        
        recipe.execution = emptyExecution
        
        let recipeDTO: RecipeDTO
        switch getDTOFromRecipe(recipe) {
        case .success(let dto):
            recipeDTO = dto
        case .failure(let error):
            return .failure(error)
        }
        
        do {
            let url = stringUrl + "recipe"
            var createdRecipeDTO: RecipeDTO = try await URLSession.shared.create(from: url, object: recipeDTO)
            createdRecipeDTO.recipeExecutionId = recipeDTO.recipeExecutionId
            return await getRecipeFromDTO(createdRecipeDTO)
        } catch {
            return .failure(error)
        }
    }
    
    func deleteRecipe(recipe: Recipe) async -> Result<Bool, Error> {
        guard let recipeId = recipe.id else {
            return .failure(RecipeDAOError.noRecipeIdInModel(recipe.title))
        }
        
        do {
            let url = stringUrl + "recipe/\(recipeId)"
            return .success(try await URLSession.shared.delete(from: url))
        } catch {
            return .failure(error)
        }
    }
    
    func getIngredientCost(recipeId: Int) async -> Result<Double, Error> {
        do {
            let url = stringUrl + "recipe/ingredient-cost/\(recipeId)"
            let ingredientCost: Double = try await URLSession.shared.get(from: url)
            return .success(ingredientCost)
        } catch {
            return .failure(error)
        }
    }
    
    func getRecipeDuration(recipeId: Int) async -> Result<Int, Error> {
        do {
            let url = stringUrl + "recipe/duration/\(recipeId)"
            let duration: Int = try await URLSession.shared.get(from: url)
            return .success(duration)
        } catch {
            return .failure(error)
        }
    }
    
    func saveRecipe(recipe: Recipe) async -> Result<Bool, Error> {
        guard let recipeId = recipe.id else {
            return .failure(RecipeDAOError.noRecipeIdInModel(recipe.title))
        }
        do {
            let url = stringUrl + "recipe/\(recipeId)"
            let recipeDTO: RecipeDTO
            switch getDTOFromRecipe(recipe) {
            case .success(let dto):
                recipeDTO = dto
            case .failure(let error):
                return .failure(error)
            }
            let updatedSuccessful: Bool = try await URLSession.shared.update(from: url, object: recipeDTO)
            return .success(updatedSuccessful)
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: -
    // MARK: private functions
    
    /**
     Gets a Recipe from a given RecipeDTO
     - parameter dto: the RecipeDTO which will be used to get the associated Recipe
     - returns: a Recipe in case of succes; an Error otherwise
     */
    private func getRecipeFromDTO(_ dto: RecipeDTO) async -> Result<Recipe, Error> {
        guard let recipeId = dto.id else {
            return .failure(RecipeDAOError.noRecipeIdInDTO(dto.name))
        }
        //        guard let executionId = dto.recipeExecutionId else {
        //            return .failure(RecipeDAOError.noRecipeExecutionIdInDTO(dto.name))
        //        }
        
        let category: Category
        switch await CategoryDAO.shared.getCategoryById(type: .recipe, id: dto.recipeCategoryId) {
        case .success(let recipeCategory):
            category = recipeCategory
        case .failure(let error):
            return .failure(error)
        }
        
        let costData: CostData
        switch await CostDataDAO.shared.getCostData(id: dto.costDataId) {
        case .success(let recipeCostData):
            costData = recipeCostData
        case .failure(let error):
            return .failure(error)
        }
        
        var execution: RecipeExecution? = nil
        if let executionId = dto.recipeExecutionId {
            switch await RecipeExecutionDAO.shared.getRecipeExecutionById(executionId) {
            case .success(let recipeExecution):
                execution = recipeExecution
            case .failure(let error):
                return .failure(error)
            }
        }
        
        return .success(Recipe(id: recipeId, title: dto.name, author: dto.author, guestsNumber: dto.guestsNumber, recipeCategory: category, costData: costData, execution: execution))
    }
    
    /**
     Gets a Recipe from a given RecipeDTO but without the informations such as cost data and ingredients and recipe execution
     - parameter dto: the RecipeDTO which will be used to get the associated Recipe
     - returns: a Recipe in case of succes; an Error otherwise
     */
    private func getRecipeHeaderFromDTO(_ dto: RecipeDTO) async -> Result<Recipe, Error> {
        guard let recipeId = dto.id else {
            return .failure(RecipeDAOError.noRecipeIdInDTO(dto.name))
        }
        //        guard let executionId = dto.recipeExecutionId else {
        //            return .failure(RecipeDAOError.noRecipeExecutionIdInDTO(dto.name))
        //        }
        
        let category: Category
        switch await CategoryDAO.shared.getCategoryById(type: .recipe, id: dto.recipeCategoryId) {
        case .success(let recipeCategory):
            category = recipeCategory
        case .failure(let error):
            return .failure(error)
        }
        
        let costData: CostData = CostData(averageHourlyCost: 0, flatrateHourlyCost: 0, coefWithCharges: 0, coefWithoutCharges: 0)
        
        return .success(Recipe(id: recipeId, title: dto.name, author: dto.author, guestsNumber: dto.guestsNumber, recipeCategory: category, costData: costData, execution: nil))
    }
    
    private func getDTOFromRecipe(_ recipe: Recipe) -> Result<RecipeDTO, Error> {
        guard let recipeCategoryId = recipe.recipeCategory.id else {
            return .failure(RecipeDAOError.noRecipeCategoryIdInModel(recipe.title))
        }
        
        guard let costDataId = recipe.costData.id else {
            return .failure(RecipeDAOError.noCostDataIdInModel(recipe.title))
        }
        
        return .success(RecipeDTO(id: recipe.id, name: recipe.title, author: recipe.author, guestsNumber: recipe.guestsNumber, recipeCategoryId: recipeCategoryId, recipeExecutionId: recipe.execution?.id, costDataId: costDataId))
    }
}
