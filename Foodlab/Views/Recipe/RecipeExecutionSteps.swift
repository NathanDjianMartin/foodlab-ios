import SwiftUI

struct RecipeExecutionSteps: View {
    @Environment(\.editMode) private var editMode
    @State private var oldEditMode: EditMode = .inactive
    @EnvironmentObject var recipeListViewModel: RecipeListViewModel
    
    @ObservedObject var viewModel: RecipeExecutionStepsViewModel
    private var intent: RecipeIntent
    
    @State private var selectedSimpleStep: SimpleStep?
    @State private var simpleStepToDelete: SimpleStep?
    @State private var showRecipeExecutionForm = false
    @State var selectedIndex: Int = -1
    
    @State var recipe: Recipe = Recipe(title: "", author: "", guestsNumber: 0, recipeCategory: Category(name: ""), costData: CostData(id: 1, averageHourlyCost: 1, flatrateHourlyCost: 1, coefWithCharges: 1, coefWithoutCharges: 1), execution: nil, duration: 1)
    
    init(viewModel: RecipeExecutionStepsViewModel, intent: RecipeIntent, recipe: Recipe) {
        self.viewModel = viewModel
        self.intent = intent
        self.recipe = recipe
        self.intent.addObserver(self.viewModel)
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Button {
                    self.selectedSimpleStep = SimpleStep(title: "", stepDescription: "", duration: 0, ingredients: [:])
                } label: {
                    Label("Add step", systemImage: "plus")
                }
                Button {
                    self.showRecipeExecutionForm = true
                } label: {
                    Label("Add recipe execution", systemImage: "plus")
                }
                Spacer()
                EditButton()
            }
            .padding()
            if self.viewModel.steps.count != 0 {
            List {
                let steps = self.viewModel.steps
                ForEach(Array(zip(steps.indices, steps)), id: \.0) { (index, step) in
                    let displayIndex = index + 1
                    if let simpleStep = step as? SimpleStep {
                        NavigationLink {
                            IngredientListInStep(ingredients: simpleStep.ingredients)
                                .navigationTitle("Ingredients")
                        } label: {
                            SimpleStepRow(step: simpleStep, index: displayIndex)
                                .fixedSize(horizontal: false, vertical: true)
                                .swipeActions {
                                    Button {
                                        Task {
                                            if let id = step.stepWithinRecipeExecutionId {
                                                await self.intent.intentToRemoveStep(id: id ,at: IndexSet(integer: index))
                                            } else {
                                                // TODO:
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.foodlabRed)
                                    
                                    Button {
                                        self.selectedSimpleStep = simpleStep
                                        self.selectedIndex = index
                                    } label: {
                                        Image(systemName: "square.and.pencil")
                                    }
                                    .tint(.foodlabTeal)
                                }
                        }
                    } else if let execution = step as? RecipeExecution {
                        NavigationLink {
                            RecipeExecutionSteps(viewModel: RecipeExecutionStepsViewModel(model: execution), intent: self.intent)
                                .navigationTitle(execution.title)
                        } label: {
                            RecipeExecutionRow(execution: execution, index: displayIndex)
                                .swipeActions {
                                    Button {
                                        Task {
                                            if let id = step.stepWithinRecipeExecutionId {
                                                await self.intent.intentToRemoveStep(id: id ,at: IndexSet(integer: index))
                                            } 
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.foodlabRed)
                                }
                        }
                    }
                }
                .onMove { source, destination in
                    self.intent.intentToMoveSteps(source: source, destination: destination)
                }
            }
            .listStyle(.plain)
            }
        }
        .sheet(item: self.$selectedSimpleStep) { simpleStep in
            SimpleStepForm(viewModel: SimpleStepFormViewModel(model: simpleStep, recipeExecution: self.viewModel.model), presentedStep: self.$selectedSimpleStep, intent: self.intent, stepIndex: selectedIndex, recipe: self.recipe)
        }
        .sheet(isPresented: self.$showRecipeExecutionForm) {
            RecipeExecutionForm(viewModel: RecipeExecutionFormViewModel(recipes: self.recipeListViewModel.recipes, execution: self.viewModel.model), intent: self.intent, isPresented: self.$showRecipeExecutionForm)
        }
        .onChange(of: editMode!.wrappedValue, perform: { value in
            if value.isEditing {
                // Entering edit mode (e.g. 'Edit' tapped)
            } else {
                if value == .inactive && self.oldEditMode == .active { // leaving REAL edit mode
                    Task {
                        await self.intent.intentToUpdateRecipeExecution(self.viewModel.model)
                    }
                }
            }
            self.oldEditMode = value
        })
    }
}

struct RecipeExecutionDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeExecutionSteps(viewModel: RecipeExecutionStepsViewModel(model: MockData.executionPates), intent: RecipeIntent(), recipe: MockData.recipeCrepes)
    }
}
