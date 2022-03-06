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
    case recipeDeletedInDatabase(Int)
    case error(String)
}

enum RecipeDetailsIntentState {
    case ready
}

enum RecipeExecutionStepsIntentState {
    case ready
    case updatingSimpleStep(SimpleStep, Int)
    case addingStep(Step)
    case removingStep(IndexSet)
    case movingSteps(IndexSet, Int)
}

enum SimpleStepFormIntentState {
    case ready
    case error(String)
    case stepTitleChanging(String)
    case stepDescriptionChanging(String)
    case stepDurationChanging(Int)
    case addIngredientInStep((Ingredient,Double))
    case simpleStepAddedInDatabase
    case deleteIngredientInStep(Ingredient)
    case simpleStepUpdatedInDatabase
}

enum RecipeExecutionFormIntentState {
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
    private var recipeExecutionFormState = PassthroughSubject<RecipeExecutionFormIntentState, Never>()
    
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
    
    func addObserver(_ observer: RecipeExecutionFormViewModel) {
        self.recipeExecutionFormState.subscribe(observer)
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
        if isSimpleStepValid(simpleStep: simpleStep) {
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
            self.recipeExecutionStepsState.send(.addingStep(simpleStep))
        case .failure(let error):
            self.simpleStepFormState.send(.error(error.localizedDescription))
        }
        }
    }
    
    func intentToAddExecution(_ execution: RecipeExecution, to destinationExecution: RecipeExecution) async {
        guard let executionId = execution.id else {
            self.recipeExecutionFormState.send(.error("Error while intenting to add RecipeExecution \"\(execution.title)\" to RecipeExecution \"\(destinationExecution.title)\": \(execution.title) doesn't have an id!"))
            return
        }
        
        guard let destinationExecutionId = destinationExecution.id else {
            self.recipeExecutionFormState.send(.error("Error while intenting to add RecipeExecution \"\(execution.title)\" to RecipeExecution \"\(destinationExecution.title)\": \(destinationExecution.title) doesn't have an id!"))
            return
        }
        
        switch await StepWithinRecipeExecutionDAO.shared.addStepWithinRecipeExecution(stepId: executionId, recipeExecutionId: destinationExecutionId) {
        case .success:
            self.recipeExecutionStepsState.send(.addingStep(execution))
        case .failure(let error):
            self.recipeExecutionFormState.send(.error(error.localizedDescription))
        }
    }
    
    func intentToDelete(recipe: Recipe, at index: Int) async {
        switch await RecipeDAO.shared.deleteRecipe(recipe: recipe) {
        case .success:
            self.recipeListState.send(.recipeDeletedInDatabase(index))
        case .failure(let error):
            self.recipeListState.send(.error(error.localizedDescription))
        }
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
    
    func intentToChange(stepTitle: String){
        self.simpleStepFormState.send(.stepTitleChanging(stepTitle))
    }
    
    func intentToChange(stepDescription: String){
        self.simpleStepFormState.send(.stepDescriptionChanging(stepDescription))
    }
    
    func intentToChange(duration: Int){
        self.simpleStepFormState.send(.stepDurationChanging(duration))
    }
    
    func intentToAddIngredientInStep(ingredient: (Ingredient,Double)){
        self.simpleStepFormState.send(.addIngredientInStep(ingredient))
    }
    
    func intentToDeleteIngredientInStep(ingredient: Ingredient){
        self.simpleStepFormState.send(.deleteIngredientInStep(ingredient))
    }
    
    func intentToUpdateSimpleStep(simpleStep: SimpleStep, stepIndex: Int) async {
        // TODO: faire la requête
        switch await StepDAO.shared.updateStep(step: simpleStep) {
        case .failure(_):
            self.simpleStepFormState.send(.error("Error while updating step"))
        case .success(let isUpdated):
            if isUpdated {
                self.simpleStepFormState.send(.simpleStepUpdatedInDatabase)
                self.recipeExecutionStepsState.send(.updatingSimpleStep(simpleStep, stepIndex))
            }
        }
    }
    
    private func isSimpleStepValid(simpleStep: SimpleStep) -> Bool {
        if simpleStep.title == "" {
            self.simpleStepFormState.send(.error("Step title cannot be empty"))
            return false
        } else if simpleStep.description == "" {
            self.simpleStepFormState.send(.error("Step description cannot be empty"))
            return false
        } else {
            return true
        }
    }
}
