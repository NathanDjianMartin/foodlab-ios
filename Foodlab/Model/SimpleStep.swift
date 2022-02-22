import Foundation

class SimpleStep: Step, ObservableObject {
    
    var description: String
    var duration: Int
    //Ingredients
    var ingredients: [Ingredient: Double]?
    
    init(id: Int? = nil, title: String, stepDescription: String, duration: Int, ingredients: [Ingredient: Double]? = nil) {
        self.description = stepDescription
        self.duration = duration
        self.ingredients = ingredients
        super.init(id: id, title: title)
    }
}
