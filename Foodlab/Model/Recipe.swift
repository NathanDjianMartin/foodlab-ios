import Foundation

class Recipe: Identifiable, ObservableObject {
    
    var id: Int?
    var title: String
    var author: String
    var guestsNumber: Int
    var recipeCategory: Category
    var costData: CostData
    var execution: RecipeExecution
    
    var duration: Int {
        0
    }
    
    init(id: Int? = nil, title: String, author: String, guestsNumber: Int, recipeCategory: Category, costData: CostData, execution: RecipeExecution) {
        self.id = id
        self.title = title
        
        self.author = author
        self.guestsNumber = guestsNumber
        self.recipeCategory = recipeCategory
        self.costData = costData
        self.execution = execution
    }
}
