import Foundation

class Step: Identifiable {
    var id: Int?
    var stepWithinRecipeExecutionId: Int?
    var title: String
    
    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
