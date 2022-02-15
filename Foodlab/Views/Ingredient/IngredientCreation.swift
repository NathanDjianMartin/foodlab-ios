import SwiftUI

struct IngredientCreation: View {
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var unit: String = ""
    @State private var price: Double = 0
    @State private var stockQuantity: Double = 0
    @State private var ingredientCategory: String = ""
    @State private var allergentCategory: String = ""
        
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
                    TextField("Price", value: $price, formatter: Formatters.decimalFormatter)
                }
                
                HStack {
                    Text("Stock quantity")
                        .lineLimit(1)
                    Divider()
                    TextField("Stock quantity", value: $stockQuantity, formatter: Formatters.decimalFormatter)
                }
                
                Dropdown(placeholder: "Ingredient category", dropDownList: MockData.ingredientCategories)
                Dropdown(placeholder: "Allergen category", dropDownList: MockData.allergenCategories)
                
                HStack {
                    Spacer()
                    Button("Create ingredient") {
                        print("TODO: Create ingredient!")
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
        IngredientCreation(isPresented: .constant(true))
    }
}
