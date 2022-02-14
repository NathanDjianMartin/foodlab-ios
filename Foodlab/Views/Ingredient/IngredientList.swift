import SwiftUI

struct IngredientList: View {
    @State private var showIngredientCreation = false
    
    var body: some View {
        List {
            ForEach(MockData.ingredientList) { ingredient in
                IngredientRow(ingredient: ingredient)
            }
        }
        .sheet(isPresented: $showIngredientCreation) {
            IngredientCreation(isPresented: $showIngredientCreation)
        }
        .navigationTitle("Ingredients")
        .toolbar {
            Button(action: {
                showIngredientCreation = true
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
