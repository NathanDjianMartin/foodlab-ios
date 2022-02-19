import SwiftUI

struct RecipeList: View {
    @State private var showRecipeCreation = false
    @State private var searchText = ""
    
    var body: some View {
        
        VStack {
            Text(searchText)
            List {
                ForEach(MockData.recipeCategoriesModel) { category in
                    Section(category.name) {
                        ForEach(1..<3) { number in
                            NavigationLink {
                                RecipeDetails(recipe: MockData.recipePates)
                            } label: {
                                RecipeRow(recipe: MockData.recipePates)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search a recipe")
            .sheet(isPresented: $showRecipeCreation) {
                let newRecipe = Recipe(title: "", author: "", guestsNumber: 1, recipeCategory: MockData.entree, costData: MockData.costData, execution: RecipeExecution(title: ""))
                RecipeForm(recipe: newRecipe ,isPresented: $showRecipeCreation)
            }
            .navigationTitle("Recipes")
            .toolbar {
                Button(action: {
                    showRecipeCreation = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct RecipesList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeList()
            .preferredColorScheme(.dark)
    }
}
