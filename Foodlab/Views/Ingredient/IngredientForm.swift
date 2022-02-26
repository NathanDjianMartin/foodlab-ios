import SwiftUI

struct IngredientForm: View {
    @Binding var isPresented: Ingredient?
    
    @ObservedObject var ingredientVM: IngredientFormViewModel
    var ingredientListVM: IngredientListViewModel
    private var intent: IngredientIntent
    
    var creationMode: Bool {
        self.ingredientVM.id == nil
    }
    
    init(ingredientVM: IngredientFormViewModel, ingredientListVM: IngredientListViewModel, isPresented: Binding<Ingredient?>){
        self.ingredientVM = ingredientVM
        self.ingredientListVM = ingredientListVM
        self._isPresented = isPresented
        
        self.intent = IngredientIntent()
        self.intent.addObserver(ingredientFormViewModel: ingredientVM)
        self.intent.addObserver(ingredientListViewModel: ingredientListVM)
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
                Dropdown(placeholder: "Ingredient category", dropDownList: MockData.ingredientCategories)
                // TODO: implement onSubmit
                Dropdown(placeholder: "Allergen category", dropDownList: MockData.allergenCategories)
                
                HStack {
                    Spacer()
                    Button(creationMode ? "Create ingredient" : "Edit ingredient") {
                        //intentToCreate
                        if !creationMode {
                            // update
                            Task {
                                await intent.intentToUpdate(ingredient: ingredientVM.modelCopy)
                            }
                        } else {
                            // create
                            Task {
                                await intent.intentToCreate(ingredient: ingredientVM.modelCopy)
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
        IngredientForm(ingredientVM: IngredientFormViewModel(model: MockData.ingredient), ingredientListVM: IngredientListViewModel(ingredients: MockData.ingredientList), isPresented: .constant(MockData.ingredient))
    }
}
