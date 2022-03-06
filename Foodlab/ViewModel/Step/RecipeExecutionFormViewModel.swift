import Foundation
import Combine

class RecipeExecutionFormViewModel: ObservableObject, Subscriber {
    
    
    @Published var recipes: [Recipe]
    @Published var errorMessage: String?
    
    init(recipes: [Recipe]) {
        self.recipes = recipes
    }
    
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
