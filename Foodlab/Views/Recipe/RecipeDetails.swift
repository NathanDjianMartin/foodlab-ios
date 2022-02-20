import SwiftUI

struct RecipeDetails: View {
    var recipe: Recipe
    @State private var selectedTab: String = "steps"
    
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
            
            Picker("Tab", selection: $selectedTab) {
                Image(systemName: "list.dash").tag("steps")
                Image(systemName: "fork.knife").tag("ingredients")
                Image(systemName: "dollarsign.circle").tag("costs")
            }
            .colorMultiply(.foodlabLightBrown)
            .pickerStyle(.segmented)
            .padding()
            
            switch selectedTab {
            case "steps":
                RecipeExecutionSteps(execution: recipe.execution)
            case "ingredients":
                Text("RecipeIngredients")
            case "costs":
                Text("RecipeCosts")
            default:
                Text("ERROR, wrong selection \(selectedTab)")
                    .font(.title)
                    .foregroundColor(.red)
            }
            Spacer()
        }
    }
}

struct RecipeDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetails(recipe: MockData.recipePates)
    }
}
