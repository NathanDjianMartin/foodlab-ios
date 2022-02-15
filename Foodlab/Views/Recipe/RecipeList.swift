import SwiftUI

struct RecipeList: View {
    @State private var showRecipeCreation = false

    var body: some View {
        List {
            ForEach(1..<30) { number in
                NavigationLink {
                    RecipeDetails()
                } label: {
                    Text("Recipe n°\(number)")
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
