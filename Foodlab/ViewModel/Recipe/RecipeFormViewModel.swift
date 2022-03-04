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
    private (set) var modelCopy: Recipe
    @Published var id: Int?
    @Published var title: String // 7 (@Published)
    @Published var author: String
    @Published var guestNumber: Int
    @Published var category: Category?
    @Published var error: String?
    
    init(model: Recipe) {
        self.model = model
        self.modelCopy = model.copy() as! Recipe
        self.id = model.id
        self.title = model.title
        self.author = model.author
        self.guestNumber = model.guestsNumber
        self.category = model.recipeCategory
        self.model.addSubscriber(self)
    }
    
    
    private func validate() {
        self.model.title = self.modelCopy.title
        self.model.author = self.modelCopy.author
        self.model.guestsNumber = self.modelCopy.guestsNumber
    }
    
    
    // MARK: --
    // MARK: Recipe subscriber conformance
    // These functions are called when one of the model's properties changes.
    
    // 5
    func changed(title: String) {
        self.title = title // 6
    }
    
    func changed(author: String) {
        self.author = author
    }
    
    func changed(guestNumber: Int) {
        self.guestNumber = guestNumber
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
    func receive(_ input: RecipeFormIntentState) -> Subscribers.Demand {
        print("RecipeFormViewModel intent = \(input)")
        switch input {
        case .ready:
            break
        case .recipeTitleChanging(let newTitle):
            self.modelCopy.title = newTitle
            if self.modelCopy.title != newTitle { // the model's property did not change, there was an error
                
            }
        case .recipeAuthorChanging(let newAuthor):
            self.modelCopy.author = newAuthor
        case .recipeGuestNumberChanging(let newGuestNumber):
            self.modelCopy.guestsNumber = newGuestNumber
        case .recipeCategoryChanging(let newCategory):
            self.modelCopy.recipeCategory = newCategory
        case .validateChanges:
            self.validate()
        case .error(let error):
            self.error = error
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
