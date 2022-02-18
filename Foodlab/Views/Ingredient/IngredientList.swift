import SwiftUI

struct IngredientList: View {
    @State private var showIngredientForm = false
    @State private var showAlert = false
    @State private var ingredient = Ingredient(name: "", unit: "", unitaryPrice: 0, stockQuantity: 0, ingredientCategory: "")
    static var ingredients : [Ingredient]?
    
    var body: some View {
        
        
        List {
            ForEach(IngredientList.ingredients!.indices) { ingredientIndex in
                IngredientRow(ingredient: IngredientList.ingredients![ingredientIndex])
                    .swipeActions {
                        Button {
                            self.ingredient = MockData.ingredientList[ingredientIndex]
                            showIngredientForm = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                        .tint(.foodlabTeal)
                        Button {
                            self.showAlert = true
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.foodlabRed)
                    }
                    .alert("Delete ?", isPresented: $showAlert) {
                        Button(role: .cancel) {
                        } label: {
                            Text("No")
                        }
                        Button(role: .destructive) {
                            self.showAlert = false
                            // TODO: intentToRemoveIngredient
                        } label: {
                            Text("Yes")
                            
                        }
                    }
            }
            
        }
        .sheet(isPresented: $showIngredientForm) {
            IngredientForm(isPresented: $showIngredientForm)
        }
        .navigationTitle("Ingredients")
        .toolbar {
            Button(action: {
                showIngredientForm = true
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
