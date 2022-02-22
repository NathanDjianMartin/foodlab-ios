import SwiftUI

struct RecipeRow: View {
    var recipe: Recipe
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recipe.title)
                    .font(.headline)
                Text("By \(recipe.author)")
                    .font(.caption)
                Text("Duration: \(recipe.duration) minutes")
                    .font(.caption)
            }
            Spacer()
            // TODO: manage deletion with a swipe
        }
        .padding()
    }
}

struct RecipeRow_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRow(recipe: MockData.recipeCrepes)
    }
}
