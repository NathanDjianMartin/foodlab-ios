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
        self.stepWithinRecipeExecutionId = super.stepWithinRecipeExecutionId
    }
    
    func copy() -> SimpleStep {
        let step = SimpleStep(id: self.id, title: self.title, stepDescription: self.description, duration: self.duration, ingredients: self.ingredients)
        return step
    }
}
