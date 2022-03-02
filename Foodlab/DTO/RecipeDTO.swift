import Foundation

struct RecipeDTO: Identifiable, Codable {
    
    var id: Int?
    var name: String
    var author: String
    var guestsNumber: Int
    var recipeCategoryId: Int
    var costDataId: Int
    var recipeExecutionId: Int?
    
    internal init(id: Int? = nil, name: String, author: String, guestsNumber: Int, recipeCategoryId: Int, recipeExecutionId: Int? = nil, costDataId: Int) {
        self.id = id
        self.name = name
        self.author = author
        self.guestsNumber = guestsNumber
        self.recipeCategoryId = recipeCategoryId
        self.recipeExecutionId = recipeExecutionId
        self.costDataId = costDataId
    }
}
