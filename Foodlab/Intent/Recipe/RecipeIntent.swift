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
    case addingSimpleStep(SimpleStep)
    case removingStep(IndexSet)
    case movingSteps(IndexSet, Int)
}

enum SimpleStepFormIntentState {
    case ready
    case error(String)
}

struct RecipeIntent {
    
    // passthrough subject = publisher
    private var recipeFormState = PassthroughSubject<RecipeFormIntentState, Never>()
    private var recipeListState = PassthroughSubject<RecipeListIntentState, Never>()
    private var recipeDetailsState = PassthroughSubject<RecipeDetailsIntentState, Never>()
    private var recipeExecutionStepsState = PassthroughSubject<RecipeExecutionStepsIntentState, Never>()
    private var simpleStepFormState = PassthroughSubject<SimpleStepFormIntentState, Never>()
    
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
    
    func addObserver(_ observer: SimpleStepFormViewModel) {
        self.simpleStepFormState.subscribe(observer)
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
    
    func intentToAddSimpleStep(_ simpleStep: SimpleStep, to execution: RecipeExecution) async {
        let createdStep: Step
        switch await StepDAO.shared.createStep(step: simpleStep) {
        case .success(let step):
            createdStep = step
        case .failure(let error):
            self.simpleStepFormState.send(.error(error.localizedDescription))
            return
        }
        
        guard let simpleStep = createdStep as? SimpleStep else {
            self.simpleStepFormState.send(.error("Error while intenting to add SimpleStep \"\(simpleStep.title)\" to RecipeExecution \"\(execution.title)\": the Step is a RecipeExecution, not a SimpleStep"))
            return
        }
        
        guard let simpleStepId = createdStep.id else {
            self.simpleStepFormState.send(.error("Error while intenting to add SimpleStep \"\(simpleStep.title)\" to RecipeExecution \"\(execution.title)\": no SimpleStep id!"))
            return
        }
        
        guard let executionId = execution.id else {
            self.simpleStepFormState.send(.error("Error while intenting to add SimpleStep \"\(simpleStep.title)\" to RecipeExecution \"\(execution.title)\": no RecipeExecution id!"))
            return
        }
        
        switch await StepWithinRecipeExecutionDAO.shared.addStepWithinRecipeExecution(stepId: simpleStepId, recipeExecutionId: executionId) {
        case .success:
            self.recipeExecutionStepsState.send(.addingSimpleStep(simpleStep))
        case .failure(let error):
            self.simpleStepFormState.send(.error(error.localizedDescription))
        }
    }
    
    func intentToAddExecution(_ execution: RecipeExecution, to destinationExecution: RecipeExecution) async {
        
    }
    
    func intentToRemoveStep(id: Int, at indexSet: IndexSet) async {
        print("intentToRemoveStep at \(indexSet) called")
        switch await StepWithinRecipeExecutionDAO.shared.deleteStepWithinRecipeExecution(id: id) {
        case .failure(let error):
            self.recipeFormState.send(.error(error.localizedDescription))
        case .success(let isDeleted):
            if isDeleted {
                self.recipeExecutionStepsState.send(.removingStep(indexSet))
            }
        }
    }
    
    func intentToMoveSteps(source indexSet: IndexSet, destination index: Int) {
        self.recipeExecutionStepsState.send(.movingSteps(indexSet, index))
    }
    
    func intentToUpdateRecipeExecution(_ execution: RecipeExecution) async {
        switch await RecipeExecutionDAO.shared.saveRecipeExecution(execution) {
        case .success:
            break
        case .failure(let error):
            print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\(error.localizedDescription)")
            // TODO: send error state to RecipeStepsState
        }
    }
    
    func intentToValidate() {
        self.recipeFormState.send(.validateChanges)
    }
}
