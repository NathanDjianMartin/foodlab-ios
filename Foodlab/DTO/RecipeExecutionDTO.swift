import Foundation

struct RecipeExecutionDTO: Identifiable, Codable {
    
    var id: Int?
    var stepTitle: String
    
    init(id: Int? = nil, stepTitle: String) {
        self.id = id
        self.stepTitle = stepTitle
    }
}
