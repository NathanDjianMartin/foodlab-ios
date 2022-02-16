import Foundation

class Recipe: Identifiable {
    
    var id: Int?
    var name: String
    var author: String
    var guestsNumber: Int
    var recipeCategory: Category
    var recipeExecution: RecipeExecution?
    var costData: CostData
    
    //variable calculée
    var duration : Int
    
    internal init(id: Int? = nil, name: String, author: String, guestsNumber: Int, recipeCategory: Category, recipeExecution: RecipeExecution? = nil, costData: CostData, duration: Int) {
        self.id = id
        self.name = name
        self.author = author
        self.guestsNumber = guestsNumber
        self.recipeCategory = recipeCategory
        self.recipeExecution = recipeExecution
        self.costData = costData
        self.duration = duration 
    }
    
}
