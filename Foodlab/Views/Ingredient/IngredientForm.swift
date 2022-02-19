import SwiftUI

struct IngredientForm: View {
    
    @State private var name: String
    @State private var unit: String
    @State private var unitaryPrice: Double
    @State private var stockQuantity: Double
    @State private var ingredientCategory: Category
    @State private var allergentCategory: Category?
    @Binding var isPresented: Bool
    
    @ObservedObject var ingredientVM: IngredientFormViewModel
    var ingredientListVM: IngredientListViewModel
    private var intent : IngredientIntent
    
    init(ingredientVM: IngredientFormViewModel, ingredientListVM: IngredientListViewModel, isPresented: Binding<Bool>){
        self.ingredientVM = ingredientVM
        self.ingredientListVM = ingredientListVM
        self.intent = IngredientIntent()
        // le VM est enregistré comme souscrivant aux actions demandées (publications des modifs du state de l'Intent)
        self.intent.addObserver(ingredientFormViewModel: ingredientVM)
        self.intent.addObserver(ingredientListViewModel: ingredientListVM)
        self._isPresented = isPresented
        
        //
        self.name = ingredientVM.name
        self.unit = ingredientVM.unit
        self.unitaryPrice = ingredientVM.unitaryPrice
        self.stockQuantity = ingredientVM.stockQuantity
        self.ingredientCategory = ingredientVM.ingredientCategory
        self.allergentCategory = ingredientVM.allergenCategory
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
                    TextField("Name", text: $name)
                }
                
                HStack {
                    Text("Unit")
                    Divider()
                    TextField("Unit", text: $unit)
                }
                
                HStack {
                    Text("Price")
                    Divider()
                    TextField("Price", value: $unitaryPrice, formatter: FormatterHelper.decimalFormatter)
                }
                
                HStack {
                    Text("Stock quantity")
                        .lineLimit(1)
                    Divider()
                    TextField("Stock quantity", value: $stockQuantity, formatter: FormatterHelper.decimalFormatter)
                }
                
                Dropdown(placeholder: "Ingredient category", dropDownList: MockData.ingredientCategories)
                Dropdown(placeholder: "Allergen category", dropDownList: MockData.allergenCategories)
                
                HStack {
                    Spacer()
                    Button("Create ingredient") {
                        self.intent.intentToChange(
                            name: self.name,
                            unit: self.unit,
                            unitaryPrice: self.unitaryPrice,
                            stockQuantity: self.stockQuantity,
                            ingredientCategory: self.ingredientCategory,
                            allergenCategory: self.allergentCategory)
                        self.isPresented = false
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
        IngredientForm(ingredientVM: IngredientFormViewModel(model: MockData.ingredient), ingredientListVM: IngredientListViewModel(ingredients: MockData.ingredientList), isPresented: .constant(true))
    }
}
