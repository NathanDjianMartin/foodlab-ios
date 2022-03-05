import SwiftUI

struct RecipeList: View {
    
    @ObservedObject var viewModel: RecipeListViewModel
    private var intent: RecipeIntent
    
    @State private var showRecipeCreation = false
    @State private var appearCount = 0 // until Apple fixes the onAppear that is called twice
    
    init(viewModel: RecipeListViewModel) {
        self.viewModel = viewModel
        self.intent = RecipeIntent()
        self.intent.addObserver(self.viewModel)
    }
    
    var body: some View {
        
        VStack {
            List {
                ForEach(self.viewModel.recipes) { recipe in
                    NavigationLink {
                        RecipeDetails(viewModel: RecipeDetailsViewModel(model: recipe), intent: self.intent)
                    } label: {
                        RecipeRow(viewModel: RecipeRowViewModel(model: recipe))
                    }
                }
            }
            //.searchable(text: $searchText, prompt: "Search a recipe")
            .sheet(isPresented: $showRecipeCreation) {
                let newRecipe = Recipe(title: "", author: "", guestsNumber: 1, recipeCategory: MockData.entree, costData: MockData.costData, execution: RecipeExecution(title: ""))
                RecipeForm(viewModel: RecipeFormViewModel(model: newRecipe), intent: self.intent, isPresented: $showRecipeCreation)
            }
        }
        .navigationTitle("Recipes")
        .toolbar {
            Button(action: {
                self.showRecipeCreation = true
            }) {
                Image(systemName: "plus")
            }
        }
        .onAppear {
            if appearCount == 0 {
                Task {
                    switch await RecipeDAO.shared.getRecipeById(123) {
                    case .success(let recipe):
                        self.viewModel.recipes.append(recipe)
                    case .failure(let error):
                        self.viewModel.error = error.localizedDescription
                    }
                }
                appearCount += 1
            }
        }
    }
}

struct RecipesList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeList(viewModel: RecipeListViewModel())
            .preferredColorScheme(.dark)
    }
}
