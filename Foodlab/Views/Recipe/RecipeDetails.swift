import SwiftUI

struct RecipeDetails: View {
    var recipe: Recipe
    
    var body: some View {
        
        var cols = [GridItem](repeating: .init(.flexible()), count: 3)
        
        VStack {
            Text(recipe.name)
                .font(.largeTitle)
                .bold()
            LazyVGrid(columns: cols) {
                Text("Author")
                Text("Number of guest")
                Text("Category")
                
                Text(recipe.author)
                Text("\(recipe.guestsNumber)")
                Text(recipe.recipeCategory.name)
            }
        }
    }
}

struct RecipeDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetails(recipe: MockData.recipe)
    }
}
