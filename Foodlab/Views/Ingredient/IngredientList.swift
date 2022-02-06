import SwiftUI

struct IngredientList: View {
    @State private var ingredientCreation = false
    
    var body: some View {
        List {
            Button(action: {
                ingredientCreation = true
            }) {
                Image(systemName: "plus")
            }
            ForEach(MockData.ingredientList) { ingredient in
                IngredientRow(ingredient: ingredient)
            }
        }
        .sheet(isPresented: $ingredientCreation) {
            IngredientCreation()
        }
        .navigationTitle("Ingredients")
    }
}

struct StocksList_Previews: PreviewProvider {
    static var previews: some View {
        IngredientList()
    }
}
