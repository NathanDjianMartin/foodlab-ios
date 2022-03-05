import Foundation
import Combine

class StepFormViewModel {
    
    private var model: SimpleStep
    private var modelCopy: SimpleStep
    @Published var title: String
    @Published var description: String
    @Published var duration: Int
    @Published var ingredients: [Ingredient: Double]?
    
    init(model: SimpleStep) {
        self.model = model
        self.modelCopy = model.copy()
        self.title = model.title
        self.description = model.description
        self.duration = model.duration
        self.ingredients = model.ingredients
    }
    
    // TODO: model subscriber
    
    // TODO: combine subscriber
}
