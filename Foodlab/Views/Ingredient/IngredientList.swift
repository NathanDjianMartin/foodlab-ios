import SwiftUI

struct IngredientList: View {
    @State private var showIngredientForm = false
    @State private var showAlert = false
    
    @State private var selectedIndex = 0
    
    @ObservedObject var ingredientListVM: IngredientListViewModel = IngredientListViewModel()
    
    var body: some View {
        
        List {
            ForEach(ingredientListVM.ingredients.indices) { ingredientIndex in
                IngredientRow(ingredientVM: IngredientFormViewModel(model: ingredientListVM.ingredients[ingredientIndex]))
                        .swipeActions {
                            Button {
                                self.selectedIndex = ingredientIndex
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
            IngredientForm(ingredientVM: IngredientFormViewModel(model: ingredientListVM.ingredients[selectedIndex]), ingredientListVM: ingredientListVM, isPresented: $showIngredientForm)
            
        }
        
        .navigationTitle("Ingredients")
        .toolbar {
            Button(action: {
                showIngredientForm = true
            }) {
                Image(systemName: "plus")
            }
        }
        .task {
            if ( ingredientListVM.ingredients.count == 0 ){
            if let ingredients = await IngredientDAO.getAllIngredients() {
                ingredientListVM.ingredients = ingredients
            } else {
                print("nil GET")
            }
        }
            
        }
    }
}

struct StocksList_Previews: PreviewProvider {
    static var previews: some View {
        IngredientList()
        
    }
}
