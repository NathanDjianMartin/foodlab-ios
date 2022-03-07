import SwiftUI

struct RecipeList: View {
    
    @ObservedObject var viewModel: RecipeListViewModel
    private var intent: RecipeIntent
    
    @State private var showRecipeCreation = false
    @State private var appearCount = 0 // until Apple fixes the onAppear that is called twice
    @State private var searchText: String = ""
    @State private var recipeCategories: [Category] = []
    @State private var selectedCategory: Category?
    
    var recipesList: [Recipe] {
        var result: [Recipe] = self.viewModel.recipes
        
        if let selectedCategory = selectedCategory {
            result = result.filter { recipe in
                recipe.recipeCategory.id == selectedCategory.id
            }
        }
        
        if searchText.count > 0 {
            result = result.filter { recipe in
                return recipe.title.contains(searchText)
            }
        }
        
        return result
    }
    
    init(viewModel: RecipeListViewModel) {
        self.viewModel = viewModel
        self.intent = RecipeIntent()
        self.intent.addObserver(self.viewModel)
    }
    
    var body: some View {
        
        VStack {
            MessageView(message: self.$viewModel.error, type: .error)
            List {
                HStack {
                    Menu {
                        Button {
                            self.selectedCategory = nil
                        } label: {
                            Label("None", systemImage: "xmark")
                        }
                        ForEach(recipeCategories) { category in
                            Button {
                                self.selectedCategory = category
                            } label: {
                                Text("\(category.name)")
                                Spacer()
                                if selectedCategory?.name == category.name {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    } label: {
                        Text(selectedCategory != nil ? selectedCategory!.name : "Select recipe category")
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                }
                ForEach(Array(recipesList.enumerated()), id: \.element.self) { index, recipe in
                    NavigationLink {
                        RecipeDetails(viewModel: RecipeDetailsViewModel(model: recipe), intent: self.intent, categories: recipeCategories)
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
            .searchable(text: $searchText, prompt: "Search a recipe")
            .sheet(isPresented: $showRecipeCreation) {
                let newRecipe = Recipe(title: "", author: "", guestsNumber: 1, recipeCategory: MockData.entree, costData: MockData.costData, execution: RecipeExecution(title: ""), duration: 0)
                RecipeForm(viewModel: RecipeFormViewModel(model: newRecipe), intent: self.intent, isPresented: $showRecipeCreation, categories: recipeCategories)
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
                    switch await CategoryDAO.shared.getAllCategories(type: .recipe) {
                    case .success(let categories):
                        self.recipeCategories = categories
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
