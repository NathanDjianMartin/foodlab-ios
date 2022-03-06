import Foundation
import Combine

class SimpleStepFormViewModel: ObservableObject, Subscriber {
    
    var model: SimpleStep
    private var modelCopy: SimpleStep
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
        }
        
        return .none
    }
}
