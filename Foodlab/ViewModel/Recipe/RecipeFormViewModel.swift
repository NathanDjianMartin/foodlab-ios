import Foundation
import Combine

enum RecipeFormError: Error, CustomStringConvertible, Equatable {
    case titleEmpty
    case authorEmpty
    
    var description: String {
        switch self {
        case .titleEmpty:
            return "The title can't be empty"
        case .authorEmpty:
            return "The author can't be empty"
        }
    }
}

class RecipeFormViewModel: ObservableObject, RecipeSubscriber, Subscriber {
    
    private var model: Recipe
    private var modelCopy: Recipe
    @Published var recipeId: Int?
    @Published var recipeTitle: String // 7 (@Published)
    @Published var recipeAuthor: String
    @Published var recipeGuestNumber: Int
    
    init(model: Recipe) {
        self.model = model
        self.modelCopy = model.copy() as! Recipe
        self.recipeId = model.id
        self.recipeTitle = model.title
        self.recipeAuthor = model.author
        self.recipeGuestNumber = model.guestsNumber
        self.model.addSubscriber(self)
    }

    
    /**
     Rollbacks the changes made in the view model's view.
     */
    func rollback() {
        self.model = modelCopy
        self.recipeId = model.id
        self.recipeTitle = model.title
        self.recipeAuthor = model.author
        self.recipeGuestNumber = model.guestsNumber
    }
    
    
    // MARK: --
    // MARK: Recipe subscriber conformance
    // These functions are called when one of the model's properties changes.
    
    // 5
    func changed(title: String) {
        self.recipeTitle = title // 6
    }
    
    func changed(author: String) {
        self.recipeAuthor = author
    }
    
    func changed(guestNumber: Int) {
        self.recipeGuestNumber = guestNumber
    }
    
    // MARK: --
    // MARK: Combine subscriber conformance
        
    typealias Input = RecipeFormIntentState
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
    // Called each time the RecipeFormIntent changes its state
    func receive(_ input: RecipeFormIntentState) -> Subscribers.Demand {
        print("RecipeFormViewModel intent = \(input)")
        switch input {
        case .ready:
            break
        case .recipeTitleChanging(let newTitle):
            self.model.title = newTitle
            if self.model.title != newTitle { // the model's property did not change, there was an error
                
            }
        case .recipeAuthorChanging(let newAuthor):
            self.model.author = newAuthor
        case .recipeGuestNumberChanging(let newGuestNumber):
            self.model.guestsNumber = newGuestNumber
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
