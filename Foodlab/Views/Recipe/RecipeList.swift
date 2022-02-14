import SwiftUI

struct RecipeList: View {
    @State private var recipeCreation = false

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
        .sheet(isPresented: $recipeCreation) {
            RecipeCreation()
        }
        .toolbar {
            Button(action: {
                recipeCreation = true
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
