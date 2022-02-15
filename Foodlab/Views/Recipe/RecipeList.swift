import SwiftUI

struct RecipeList: View {
    @State private var showRecipeCreation = false

    var body: some View {
        
        List {
            ForEach(MockData.recipeCategoriesModel) { category in
                Section(category.name) {
                    ForEach(1..<3) { number in
                        NavigationLink {
                            RecipeDetails()
                        } label: {
                            RecipeRow(recipe: MockData.recipe)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showRecipeCreation) {
            RecipeCreation(isPresented: $showRecipeCreation)
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

struct RecipesList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeList()
            .preferredColorScheme(.dark)
    }
}
