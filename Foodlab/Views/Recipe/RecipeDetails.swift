import SwiftUI

enum RecipePickerSelection: String {
    case steps = "steps"
    case ingredients = "ingredients"
    case costs = "costs"
}

struct RecipeDetails: View {
    
    @ObservedObject var viewModel: RecipeDetailsViewModel
    private var intent: RecipeIntent
    
    @State private var selectedTab: RecipePickerSelection = .steps
    @State private var showRecipeForm = false
    
    
    init(viewModel: RecipeDetailsViewModel, intent: RecipeIntent) {
        self.viewModel = viewModel
        self.intent = intent
        self.intent.addObserver(viewModel)
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.title)
                        .font(.largeTitle)
                        .bold()
                    Text("by \(viewModel.author)")
                }
                Spacer()
                Badge(text: viewModel.category.name, color: .foodlabTeal)
                Badge(text: "For \(viewModel.guestNumber) guest\(viewModel.guestNumber > 1 ? "s" : "")", color: .foodlabLightBrown)
            }
            .padding(.leading)
            .padding(.trailing)
            
            Picker("Tab", selection: $selectedTab) {
                Image(systemName: "list.dash").tag(RecipePickerSelection.steps)
                Image(systemName: "fork.knife").tag(RecipePickerSelection.ingredients)
                Image(systemName: "dollarsign.circle").tag(RecipePickerSelection.costs)
            }
            .colorMultiply(.foodlabLightBrown)
            .pickerStyle(.segmented)
            .padding()
            
            switch selectedTab {
            case .steps:
                if let execution = self.viewModel.model.execution {
                    RecipeExecutionSteps(viewModel: RecipeExecutionStepsViewModel(model: execution), intent: self.intent)
                } else {
                    Text("This recipe is empty")
                }
            case .ingredients:
                IngredientInRecipeList(recipeExecution: viewModel.model.execution)
            case .costs:
                // TODO: récupérer les informations mais je sais pas où mettre le await 
                CostView(viewModel: CostDataViewModel(model: viewModel.model.costData), intent: CostDataIntent(), recipeId: viewModel.model.id!)
            }
            Spacer()
        }
        .toolbar {
            Button {
                self.showRecipeForm = true
            } label: {
                Image(systemName: "square.and.pencil")
            }
        }
        .navigationBarTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showRecipeForm) {
            RecipeForm(viewModel: RecipeFormViewModel(model: viewModel.model), intent: self.intent, isPresented: $showRecipeForm)
        }
    }
}

struct RecipeDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetails(viewModel: RecipeDetailsViewModel(model: MockData.recipeCrepes), intent: RecipeIntent())
    }
}
