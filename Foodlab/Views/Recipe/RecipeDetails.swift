import SwiftUI

struct RecipeDetails: View {
    var recipe: Recipe
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(recipe.title)
                        .font(.largeTitle)
                        .bold()
                    Text("by \(recipe.author)")
                }
                Spacer()
                Badge(text: recipe.recipeCategory.name, color: .foodlabTeal)
                Badge(text: "For \(recipe.guestsNumber) persons", color: .foodlabLightBrown)
            }
            .padding()
            
            RecipeExecutionSteps(execution: recipe.execution)
        }
    }
}

struct RecipeDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetails(recipe: MockData.recipePates)
    }
}
