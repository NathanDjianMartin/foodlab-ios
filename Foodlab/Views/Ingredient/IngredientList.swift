import SwiftUI

struct IngredientList: View {
    @State private var ingredientCreation = false
    
    var body: some View {
        List {
            ForEach(MockData.ingredientList) { ingredient in
                IngredientRow(ingredient: ingredient)
            }
        }
        .sheet(isPresented: $ingredientCreation) {
            IngredientCreation()
        }
        .navigationTitle("Ingredients")
        .toolbar {
            Button(action: {
                ingredientCreation = true
            }) {
                Image(systemName: "plus")
            }
        }
    }
}

struct StocksList_Previews: PreviewProvider {
    static var previews: some View {
        IngredientList()
    }
}
