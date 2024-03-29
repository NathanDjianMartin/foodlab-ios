import Foundation

struct StepWithinRecipeExecutionDTO: Identifiable, Codable {
    
    var id: Int?
    var number: Int?
    var recipeExecutionId: Int
    var stepId: Int
    
    init(id: Int? = nil, number: Int? = nil, recipeExecutionId: Int, stepId: Int) {
        self.id = id
        self.number = number
        self.recipeExecutionId = recipeExecutionId
        self.stepId = stepId
    }
}

