import SwiftUI

struct IngredientForm: View {
    
    @Binding var isPresented: Ingredient?
    @ObservedObject var ingredientVM: IngredientFormViewModel
    private var intent: IngredientIntent
    
    var creationMode: Bool {
        self.ingredientVM.id == nil
    }
    
    init(ingredientVM: IngredientFormViewModel, intent: IngredientIntent, isPresented: Binding<Ingredient?>){
        self.ingredientVM = ingredientVM
        self._isPresented = isPresented
        
        self.intent = intent
        self.intent.addObserver(ingredientFormViewModel: ingredientVM)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.isPresented = nil
                }) {
                    Text("Cancel")
                }
            }
            .padding()
            ErrorView(error: $ingredientVM.error)
            List {
                
                TextField("Name", text: $ingredientVM.name)
                    .onSubmit {
                        intent.intentToChange(name: ingredientVM.name)
                    }
                
                TextField("Unit", text: $ingredientVM.unit)
                    .onSubmit {
                        intent.intentToChange(unit: ingredientVM.unit)
                    }
                
                HStack {
                    Text("Unitary price")
                        .lineLimit(1)
                    Divider()
                    TextField("Price", value: $ingredientVM.unitaryPrice, formatter: FormatterHelper.decimalFormatter)
                        .onSubmit {
                            intent.intentToChange(unitaryPrice: ingredientVM.unitaryPrice)
                        }
                }
                
                HStack {
                    Text("Stock quantity")
                        .lineLimit(1)
                    Divider()
                    TextField("Stock quantity", value: $ingredientVM.stockQuantity, formatter: FormatterHelper.decimalFormatter)
                        .onSubmit {
                            intent.intentToChange(stockQuantity: ingredientVM.stockQuantity)
                        }
                }
                
                //TODO: gerer les categories
                CategoryDropdown(placeholder: "Ingredient category", dropDownList: MockData.ingredientCategories)
                // TODO: implement onSubmit
                CategoryDropdown(placeholder: "Allergen category", dropDownList: MockData.allergenCategories)
                
                HStack {
                    Spacer()
                    Button(creationMode ? "Create ingredient" : "Confirm changes") {
                        //intentToCreate
                        if !creationMode {
                            // update
                            Task {
                                await intent.intentToUpdate(ingredient: ingredientVM.modelCopy)
                                self.isPresented = nil
                            }
                        } else {
                            // create
                            Task {
                                await intent.intentToCreate(ingredient: ingredientVM.modelCopy)
                                self.isPresented = nil
                            }
                        }
                    }
                    .buttonStyle(DarkRedButtonStyle())
                }
            }
            .listStyle(.plain)
            .padding()
        }
    }
}

struct IngredientCreation_Previews: PreviewProvider {
    
    static var previews: some View {
        IngredientForm(ingredientVM: IngredientFormViewModel(model: MockData.ingredient), intent: IngredientIntent(), isPresented: .constant(MockData.ingredient))
    }
}
