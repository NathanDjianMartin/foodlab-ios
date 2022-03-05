import Foundation
import Combine

enum RecipeFormIntentState {
    case ready
    case recipeTitleChanging(String)
    case recipeAuthorChanging(String)
    case recipeGuestNumberChanging(Int)
    case recipeCategoryChanging(Category)
    case validateChanges
    case error(String)
}

enum RecipeListIntentState {
    case ready
    case recipeCreatedInDatabase(Recipe)
}

enum RecipeDetailsIntentState {
    case ready
}

enum RecipeExecutionStepsIntentState {
    case ready
    case removingStep(IndexSet)
    case movingSteps(IndexSet, Int)
}

struct RecipeIntent {
    
    // passthrough subject = publisher
    private var recipeFormState = PassthroughSubject<RecipeFormIntentState, Never>()
    private var recipeListState = PassthroughSubject<RecipeListIntentState, Never>()
    private var recipeDetailsState = PassthroughSubject<RecipeDetailsIntentState, Never>()
    private var recipeExecutionStepsState = PassthroughSubject<RecipeExecutionStepsIntentState, Never>()
    
    
    // MARK: -
    // MARK: add observer functions
    
    func addObserver(_ observer: RecipeFormViewModel) {
        self.recipeFormState.subscribe(observer)
    }
    
    func addObserver(_ observer: RecipeListViewModel) {
        self.recipeListState.subscribe(observer)
    }
    
    func addObserver(_ observer: RecipeDetailsViewModel) {
        self.recipeDetailsState.subscribe(observer)
    }
    
    func addObserver(_ observer: RecipeExecutionStepsViewModel) {
        self.recipeExecutionStepsState.subscribe(observer)
    }
    
    
    // MARK: -
    // MARK: intent to change state functions
    
    func intentToChange(recipeTitle: String) {
        self.recipeFormState.send(.recipeTitleChanging(recipeTitle))
    }
    
    func intentToChange(author: String) {
        self.recipeFormState.send(.recipeAuthorChanging(author))
    }
    
    func intentToChange(guestNumber: Int) {
        self.recipeFormState.send(.recipeGuestNumberChanging(guestNumber))
    }
    
    func intentToChange(category: Category) {
        self.recipeFormState.send(.recipeCategoryChanging(category))
    }
    
    func intentToCreate(recipe: Recipe) async {
        switch await RecipeDAO.shared.createRecipe(recipe: recipe) {
        case .success(let createdRecipe):
            self.recipeListState.send(.recipeCreatedInDatabase(createdRecipe))
        case .failure(let error):
            self.recipeFormState.send(.error(error.localizedDescription))
        }
    }
    
    func intentToSave(recipe: Recipe) async {
        switch await RecipeDAO.shared.saveRecipe(recipe: recipe) {
        case .success:
            print("Recipe \(recipe.title) saved in database!")
            self.recipeFormState.send(.validateChanges)
        case .failure(let error):
            self.recipeFormState.send(.error(error.localizedDescription))
        }
    }
    
    func intentToRemoveStep(at indexSet: IndexSet) {
        print("intentToRemoveStep at \(indexSet) called")
//        for i in indexSet {
//            // TODO: make request in database
//        }
        self.recipeExecutionStepsState.send(.removingStep(indexSet))
    }
    
    func intentToMoveSteps(source indexSet: IndexSet, destination index: Int) {
        self.recipeExecutionStepsState.send(.movingSteps(indexSet, index))
    }
    
    func intentToValidate() {
        self.recipeFormState.send(.validateChanges)
    }
}
