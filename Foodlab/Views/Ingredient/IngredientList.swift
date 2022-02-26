import SwiftUI

struct IngredientList: View {
    @State private var showAlert = false
    @State var selectedIngredient : Ingredient? = nil
    
    @ObservedObject var ingredientListVM: IngredientListViewModel = IngredientListViewModel()
    
    var body: some View {
        
        // if self.ingredientListVM.ingredients.count > 0 {
        List {
            if self.ingredientListVM.ingredients.count <= 0 {
                VStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                    Text("We're gathering the ingredients :)")
                }
            }
            ForEach(Array(ingredientListVM.ingredients.enumerated()), id: \.element.self) { ingredientIndex, ingredient in
                IngredientRow(ingredientVM: IngredientFormViewModel(model: ingredient ))
                    .swipeActions {
                        Button {
                            self.selectedIngredient = ingredient
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
                if ingredientListVM.ingredients.count == 0 {
                    switch  await IngredientDAO.getAllIngredients() {
                    case .failure(let error):
                        print(error)
                        break
                    case .success(let ingredients):
                        self.ingredientListVM.ingredients = ingredients
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
                self.selectedIngredient = Ingredient(name: "", unit: "", unitaryPrice: 0, stockQuantity: 0, ingredientCategory: Category(id: 19, name: ""))
            }) {
                Image(systemName: "plus")
            }
        }
        //        } else {
        //            VStack {
        //                ProgressView()
        //                    .progressViewStyle(.circular)
        //                Text("We're gathering the ingredients from the database :)")
        //            }
        //
        //        }
    }
}

struct StocksList_Previews: PreviewProvider {
    static var previews: some View {
        IngredientList()
        
    }
}
