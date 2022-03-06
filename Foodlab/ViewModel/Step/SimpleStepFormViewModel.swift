import Foundation
import Combine

class SimpleStepFormViewModel: ObservableObject, Subscriber {
    
    var model: SimpleStep
    var modelCopy: SimpleStep
    var recipeExecution: RecipeExecution
    
    var id: Int?
    @Published var title: String
    @Published var description: String
    @Published var duration: Int
    @Published var ingredients: [Ingredient: Double]?
    
    @Published var errorMessage: String?
    
    init(model: SimpleStep, recipeExecution: RecipeExecution) {
        self.id = model.id
        self.title = model.title
        self.description = model.description
        self.duration = model.duration
        self.ingredients = model.ingredients
        
        self.model = model
        self.modelCopy = model.copy()
        self.recipeExecution = recipeExecution
        // TODO: self.model.addObserver(self)
    }
    
    // TODO: model delegate
    // ...
    
    // MARK: -
    // MARK: Subscriber conformance
    
    typealias Input = SimpleStepFormIntentState
    typealias Failure = Never
    
    // Called by Subscriber protocol during subscription
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    // Called if the publisher says it finished emitting (doesn't concern us)
    func receive(completion: Subscribers.Completion<Failure>) {
        return
    }
    
    // Called each time the publisher calls the "send" method to notify about state modification
    func receive(_ input: SimpleStepFormIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .error(let errorMessage):
            self.errorMessage = errorMessage
        case .stepTitleChanging(let title):
            self.modelCopy.title = title
        case .stepDescriptionChanging(let description):
            self.modelCopy.description = description
        case .stepDurationChanging(let duration):
            self.modelCopy.duration = duration
        case .addIngredientInStep(let ingredient):
            if let ingredients = self.modelCopy.ingredients {
                self.modelCopy.ingredients![ingredient.0] = ingredient.1
            } else {
                self.modelCopy.ingredients = [:]
                self.modelCopy.ingredients![ingredient.0] = ingredient.1
            }
            if let ingredients = self.ingredients {
                self.ingredients![ingredient.0] = ingredient.1
            } else {
                self.ingredients = [:]
                self.ingredients![ingredient.0] = ingredient.1
            }
        case .deleteIngredientInStep(let ingredient):
            self.ingredients?.removeValue(forKey: ingredient)
        case .simpleStepUpdatedInDatabase:
            self.model.title = self.modelCopy.title
            self.model.description = self.modelCopy.description
            self.model.duration = self.modelCopy.duration
            self.model.ingredients = self.modelCopy.ingredients
        }
        
        return .none
    }
}
