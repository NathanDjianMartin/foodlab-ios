import Foundation
import Combine

enum RecipeFormIntentState {
    case ready
    case recipeTitleChanging(String)
    case recipeAuthorChanging(String)
    case recipeGuestNumberChanging(Int)
    case validateChanges
}

struct RecipeFormIntent {
    
    // passthrough subject = publisher
    private var recipeFormStateSubject = PassthroughSubject<RecipeFormIntentState, Never>()
    
    func addObserver(_ observer: RecipeFormViewModel) {
        self.recipeFormStateSubject.subscribe(observer)
    }
    
    // MARK: intent to change state functions
    
    func intentToChange(recipeTitle: String) {
        self.recipeFormStateSubject.send(.recipeTitleChanging(recipeTitle))
    }
    
    func intentToChange(author: String) {
        self.recipeFormStateSubject.send(.recipeAuthorChanging(author))
    }
    
    func intentToChange(guestNumber: Int) {
        self.recipeFormStateSubject.send(.recipeGuestNumberChanging(guestNumber))
    }
    
    func intentToValidate() {
        self.recipeFormStateSubject.send(.validateChanges)
    }
}
