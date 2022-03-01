import SwiftUI

struct IngredientForm: View {
    
    @Binding var isPresented: Ingredient?
    @ObservedObject var viewModel: IngredientFormViewModel
    private var intent: IngredientIntent
    
    var creationMode: Bool {
        self.viewModel.id == nil
    }
    
    init(ingredientVM: IngredientFormViewModel, intent: IngredientIntent, isPresented: Binding<Ingredient?>){
        self.viewModel = ingredientVM
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
            ErrorView(error: $viewModel.error)
            List {
                
                TextField("Name", text: $viewModel.name)
                    .onSubmit {
                        intent.intentToChange(name: viewModel.name)
                    }
                
                TextField("Unit", text: $viewModel.unit)
                    .onSubmit {
                        intent.intentToChange(unit: viewModel.unit)
                    }
                
                HStack {
                    Text("Unitary price")
                        .lineLimit(1)
                    Divider()
                    TextField("Price", value: $viewModel.unitaryPrice, formatter: FormatterHelper.decimalFormatter)
                        .onSubmit {
                            intent.intentToChange(unitaryPrice: viewModel.unitaryPrice)
                        }
                }
                
                HStack {
                    Text("Stock quantity")
                        .lineLimit(1)
                    Divider()
                    TextField("Stock quantity", value: $viewModel.stockQuantity, formatter: FormatterHelper.decimalFormatter)
                        .onSubmit {
                            intent.intentToChange(stockQuantity: viewModel.stockQuantity)
                        }
                }
                
                //TODO: gerer les categories
                CategoryDropdown(selectedCategory: viewModel.ingredientCategory, placeholder: "Ingredient category", dropDownList: MockData.ingredientCategories, canBeEmpty: false)
                // TODO: implement onSubmit
                CategoryDropdown(selectedCategory: viewModel.allergenCategory, placeholder: "Allergen category", dropDownList: MockData.allergenCategories)
                
                HStack {
                    Spacer()
                    Button(creationMode ? "Create ingredient" : "Confirm changes") {
                        //intentToCreate
                        if !creationMode {
                            // update
                            Task {
                                await intent.intentToUpdate(ingredient: viewModel.modelCopy)
                                self.isPresented = nil
                            }
                        } else {
                            // create
                            Task {
                                await intent.intentToCreate(ingredient: viewModel.modelCopy)
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
