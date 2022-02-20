import SwiftUI

struct RecipeForm: View {
    @ObservedObject var recipe: Recipe
    @Binding var isPresented: Bool
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.isPresented = false
                }) {
                    Text("Cancel")
                }
            }
            .padding()
            
            HStack {
                Text(recipe.id == nil ? "Recipe creation" : "Recipe modification")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            
            List {
                TextField("Recipe title", text: $recipe.title)
                TextField("Author", text: $recipe.author)
                Stepper(value: $recipe.guestsNumber) {
                    Text("For \(recipe.guestsNumber) guest\(recipe.guestsNumber > 1 ? "s" : "")")
                }
            }
            .listStyle(.plain)
        }
        //TODO: add button validate? 
    }
}

struct RecipeCreation_Previews: PreviewProvider {
    static var previews: some View {
        RecipeForm(recipe: MockData.recipePates, isPresented: .constant(true))
    }
}
