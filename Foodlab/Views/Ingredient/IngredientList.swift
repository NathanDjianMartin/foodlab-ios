import SwiftUI

struct IngredientList: View {
    @State private var showIngredientCreation = false
    @State private var showAlert = false
    @State private var toggle = false
    
    var body: some View {
        List {
            ForEach(MockData.ingredientList.indices) { ingredientIndex in
                IngredientRow(ingredient: MockData.ingredientList[ingredientIndex])
                    .swipeActions {
                        Button {
                            self.showAlert = true
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                    .alert("Delete ?", isPresented: $showAlert) {
                        Button(role: .cancel) {
                        } label: {
                            Text("No")
                        }
                        Button(role: .destructive) {
                            self.toggle.toggle()
                            deleteIngredient(at: ingredientIndex)
                        } label: {
                            Text("Yes")
                        }
                    }
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
    
    func deleteIngredient(at indexSet: Int) {
        self.showAlert = true
    }
}

struct StocksList_Previews: PreviewProvider {
    static var previews: some View {
        IngredientList()
        
    }
}
