import Foundation
import Combine

class RecipeListViewModel: ObservableObject, Subscriber {
    
    @Published var recipes : [Recipe]
    @Published var error: String?
    
    init(recipes: [Recipe] = []) {
        self.recipes = recipes
    }
    
    // MARK: -
    // MARK: Subscriber conformance
    
    typealias Input = RecipeListIntentState
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
    func receive(_ input: RecipeListIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .recipeCreatedInDatabase(let createdRecipe):
            self.recipes.append(createdRecipe)
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
