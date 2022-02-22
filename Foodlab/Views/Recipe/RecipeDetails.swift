import SwiftUI

struct RecipeDetails: View {
    var recipe: Recipe // TODO: use a VM
    @ObservedObject var viewModel: RecipeDetailsViewModel
    @State private var selectedTab: String = "steps"
    @State private var showRecipeForm = false
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self.viewModel = RecipeDetailsViewModel(model: recipe)
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
                Badge(text: "For \(viewModel.guestNumber) persons", color: .foodlabLightBrown)
            }
            .padding()
            
            Picker("Tab", selection: $selectedTab) {
                Image(systemName: "list.dash").tag("steps")
                Image(systemName: "fork.knife").tag("ingredients")
                Image(systemName: "dollarsign.circle").tag("costs")
            }
            .colorMultiply(.foodlabLightBrown)
            .pickerStyle(.segmented)
            .padding()
            
            switch selectedTab {
            case "steps":
                RecipeExecutionSteps(execution: recipe.execution)
            case "ingredients":
                Text("RecipeIngredients")
            case "costs":
                Text("RecipeCosts")
            default:
                Text("ERROR, wrong selection \(selectedTab)")
                    .font(.title)
                    .foregroundColor(.red)
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
        .sheet(isPresented: $showRecipeForm) {
            RecipeForm(viewModel: RecipeFormViewModel(model: recipe), isPresented: $showRecipeForm)
        }
    }
}

struct RecipeDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetails(recipe: MockData.recipePates)
    }
}
