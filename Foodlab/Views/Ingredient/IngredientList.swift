import SwiftUI

struct IngredientList: View {
    @State private var showIngredientForm = false
    @State private var showAlert = false
    
    @State private var selectedIndex = 0
    @State var selectedIngredient : Ingredient? = nil
    
    @ObservedObject var ingredientListVM: IngredientListViewModel = IngredientListViewModel()
    
    var body: some View {
        
        List {
            ForEach(Array(ingredientListVM.ingredients.enumerated()), id: \.element.self) { ingredientIndex, ingredient in
                IngredientRow(ingredientVM: IngredientFormViewModel(model: ingredient ))
                    .swipeActions {
                        Button {
                            self.selectedIngredient = ingredient
                            selectedIndex = ingredientIndex
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
        .onAppear {
            Task{
                if ( ingredientListVM.ingredients.count == 0 ){
                    switch  await IngredientDAO.getAllIngredients() {
                    case .failure(let error):
                        print(error)
                        break
                    case .success(let ingredients):
                        self.ingredientListVM.ingredients = ingredients
//                        ingredientListVM.objectWillChange.send()
                        print(self.ingredientListVM.ingredients)
                    }
                }
            }
        }
        .sheet(item: self.$selectedIngredient) { ingredient in
            IngredientForm(ingredientVM: IngredientFormViewModel(model: ingredient), ingredientListVM: ingredientListVM, isPresented: $selectedIngredient)
            
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
