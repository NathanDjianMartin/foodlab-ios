import Foundation

class RecipeExecutionDAO {
    
    static let shared: RecipeExecutionDAO = {
       return RecipeExecutionDAO()
    }()
    
    private init() {}
    
    func getRecipeExecutionById(_ id: Int) async -> Result<RecipeExecution, Error> {
        // TODO: implement this function!
        return .success(RecipeExecution(title: "TEST A SUPPRIMER"))
    }
}
