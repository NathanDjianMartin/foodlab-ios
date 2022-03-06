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
            MessageView(message: self.$viewModel.error, type: .error)
            List {
                ForEach(Array(viewModel.recipes.enumerated()), id: \.element.self) { index, recipe in
                    NavigationLink {
                        RecipeDetails(viewModel: RecipeDetailsViewModel(model: recipe), intent: self.intent)
                            .environmentObject(self.viewModel)
                    } label: {
                        RecipeRow(viewModel: RecipeRowViewModel(model: recipe))
                    }
                    .swipeActions {
                        Button {
                            Task {
                                await self.intent.intentToDelete(recipe: recipe, at: index)
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.foodlabRed)
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
                    switch await RecipeDAO.shared.getAllRecipes() {
                    case .success(let recipes):
                        self.viewModel.recipes = recipes
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
