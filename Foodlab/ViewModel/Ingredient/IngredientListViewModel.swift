import Combine
import Foundation

class IngredientListViewModel: ObservableObject {
    
    @Published var ingredients : [Ingredient]
    @Published var error: String?
    
    init(ingredients: [Ingredient] = []) {
        self.ingredients = ingredients
    }
    
    // MARK: -
    // MARK: Subscriber conformance
    
    typealias Input = IngredientListIntentState
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
    func receive(_ input: IngredientListIntentState) -> Subscribers.Demand {
        switch input {
        case .uptodate:
            break
        case .addingIngredient(let ingredient):
            self.ingredients.append(ingredient)
        case .deletingIngredient(let ingredientIndex):
            self.ingredients.remove(at: ingredientIndex)
        case .error(let errorMessage):
            self.error = errorMessage
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
