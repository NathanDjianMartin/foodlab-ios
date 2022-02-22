import SwiftUI

struct IngredientForm: View {
    @Binding var isPresented: Bool
    
    @ObservedObject var ingredientVM: IngredientFormViewModel
    var ingredientListVM: IngredientListViewModel
    private var intent : IngredientIntent
    
    init(ingredientVM: IngredientFormViewModel, ingredientListVM: IngredientListViewModel, isPresented: Binding<Bool>){
        self.ingredientVM = ingredientVM
        self.ingredientListVM = ingredientListVM
        self._isPresented = isPresented

        self.intent = IngredientIntent()
        // le VM est enregistré comme souscrivant aux actions demandées (publications des modifs du state de l'Intent)
        self.intent.addObserver(ingredientFormViewModel: ingredientVM)
        self.intent.addObserver(ingredientListViewModel: ingredientListVM)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.isPresented = false
                }) {
                    Text("Cancel")
                }
            }
            .padding()
            List {
                HStack {
                    Text("Name")
                    Divider()
                    TextField("Name", text: $ingredientVM.name)
                        .onSubmit {
                            intent.intentToChange(name: ingredientVM.name)
                        }
                }
                
                HStack {
                    Text("Unit")
                    Divider()
                    TextField("Unit", text: $ingredientVM.unit)
                        .onSubmit {
                            intent.intentToChange(unit: ingredientVM.unit)
                        }
                }
                
                HStack {
                    Text("Price")
                    Divider()
                    TextField("Price", value: $ingredientVM.unitaryPrice, formatter: FormatterHelper.decimalFormatter)
                }
                
                HStack {
                    Text("Stock quantity")
                        .lineLimit(1)
                    Divider()
                    TextField("Stock quantity", value: $ingredientVM.stockQuantity, formatter: FormatterHelper.decimalFormatter)
                }
                
                //TODO: gerer les categories
                Dropdown(placeholder: "Ingredient category", dropDownList: MockData.ingredientCategories)
                Dropdown(placeholder: "Allergen category", dropDownList: MockData.allergenCategories)
                
                HStack {
                    Spacer()
                    Button("Create ingredient") {
                        //intentToCreate
                        if (ingredientVM.modelCopy.id != nil) {
                            // update
                            Task {
                                await intent.intentToUpdate(ingredient: ingredientVM.modelCopy)
                            }
                        }
                        
                    }
                    .buttonStyle(DarkRedButtonStyle())
                    
                    /*Button("retourner"){
                        self.isPresented = false
                    }*/
                    
                }                
            }
            .listStyle(.plain)
            .padding()
        }
    }
}

struct IngredientCreation_Previews: PreviewProvider {

    static var previews: some View {
        IngredientForm(ingredientVM: IngredientFormViewModel(model: MockData.ingredient), ingredientListVM: IngredientListViewModel(ingredients: MockData.ingredientList), isPresented: .constant(true))
    }
}
