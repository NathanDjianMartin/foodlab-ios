import SwiftUI

struct IngredientForm: View {
    
    @Binding var isPresented: Ingredient?
    @ObservedObject var viewModel: IngredientFormViewModel
    private var intent: IngredientIntent
    @State var ingredientCategories: [Category] = []
    @State var allergenCategories: [Category] = []
    
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
            MessageView(message: $viewModel.error, type: TypeMessage.error)
            List {
                
                TextField("Name", text: $viewModel.name)
                    .onSubmit {
                        intent.intentToChange(name: viewModel.name)
                    }
                HStack {
                    TextField("Price", value: $viewModel.unitaryPrice, formatter: FormatterHelper.decimalFormatter)
                        .onSubmit {
                            intent.intentToChange(unitaryPrice: viewModel.unitaryPrice)
                        }
                    Text("/")
                        .foregroundColor(.secondary)
                    TextField("Unit", text: $viewModel.unit)
                        .onSubmit {
                            intent.intentToChange(unit: viewModel.unit)
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
                
                CategoryDropdown(selectedCategory: $viewModel.ingredientCategory, placeholder: "Ingredient category", dropDownList: ingredientCategories, canBeEmpty: false)
                    .onChange(of: self.viewModel.ingredientCategory) { ingredientCategory in
                        if let realIngredientCategory = ingredientCategory {
                            self.intent.intentToChange(ingredientCategory: realIngredientCategory)
                        }
                    }
                CategoryDropdown(selectedCategory: $viewModel.allergenCategory, placeholder: "Allergen category", dropDownList: allergenCategories)
                    .onChange(of: self.viewModel.allergenCategory) { allergenCategory in
                        if let realAllergenCategory = allergenCategory {
                            self.intent.intentToChange(allergenCategory: realAllergenCategory)
                        }
                    }
                
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
                                if let error = viewModel.error {
                                    print(error)
                                } else {
                                    self.isPresented = nil
                                }
                            }
                        }
                    }
                    .buttonStyle(DarkRedButtonStyle())
                }
            }
            .listStyle(.plain)
            .padding()
        }
        .onAppear {
            Task {
                switch await CategoryDAO.shared.getAllCategories(type: CategoryType.ingredient) {
                case .failure(let error):
                    print(error)
                    self.viewModel.error = "Error while fletching ingredient categories"
                case .success(let categories):
                    ingredientCategories = categories
                    if ingredientCategories.count > 0 {
                        self.viewModel.ingredientCategory = ingredientCategories[0]
                    }
                }
                switch await CategoryDAO.shared.getAllCategories(type: CategoryType.allergen) {
                case .failure(let error):
                    print(error)
                    self.viewModel.error = "Error while fletching allergen categories"
                case .success(let categories):
                    allergenCategories = categories
                }

            }
        }
    }
}

struct IngredientCreation_Previews: PreviewProvider {
    
    static var previews: some View {
        IngredientForm(ingredientVM: IngredientFormViewModel(model: MockData.ingredient), intent: IngredientIntent(), isPresented: .constant(MockData.ingredient))
    }
}
