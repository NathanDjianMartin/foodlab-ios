import Foundation
import Combine

class RecipeDetailsViewModel: ObservableObject, Subscriber, RecipeSubscriber {

    var model: Recipe
    @Published var title: String
    @Published var author: String
    @Published var category: Category
    @Published var guestNumber: Int
    
    init(model: Recipe) {
        self.model = model
        self.title = model.title
        self.author = model.author
        self.category = model.recipeCategory
        self.guestNumber = model.guestsNumber
        self.model.addSubscriber(self)
        print("subscribed")
    }
    
    func changed(title: String) {
        self.title = title
    }
    
    func changed(author: String) {
        self.author = author
    }
    
    func changed(guestNumber: Int) {
        self.guestNumber = guestNumber
    }
    
    // MARK: -
    // MARK: Combine subscriber conformance
    
    typealias Input = RecipeDetailsIntentState
    typealias Failure = Never
    
    // Called by Subscriber protocol during subscription
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    // Called if the publisher says it finished emitting
    func receive(completion: Subscribers.Completion<Failure>) {
        return // TODO: see what's the use
    }
    
    // 4
    func receive(_ input: RecipeDetailsIntentState) -> Subscribers.Demand {
        print("RecipeFormViewModel intent = \(input)")
        switch input {
        case .ready:
            break
        case .recipeUpdatedInDatabase(let recipe):
            break
//            self.model.title = recipe.title
//            self.model.author = recipe.author
//            self.model.recipeCategory = recipe.recipeCategory
//            self.model.guestsNumber = recipe.guestsNumber
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
