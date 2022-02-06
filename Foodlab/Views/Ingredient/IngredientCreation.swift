import SwiftUI

struct IngredientCreation: View {
    @State private var name: String = ""
    @State private var unit: String = ""
    @State private var price: Double = 0
    @State private var stockQuantity: Double = 0
    @State private var ingredientCategory: String = ""
    @State private var allergentCategory: String = ""
    
    let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    private var columns = [GridItem(.adaptive(minimum: 300))]
    
    var body: some View {
        NavigationView {
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
                    TextField("Price", value: $price, formatter: decimalFormatter)
                }
                
                HStack {
                    Text("Stock quantity")
                        .lineLimit(1)
                    Divider()
                    TextField("Stock quantity", value: $stockQuantity, formatter: decimalFormatter)
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
                .padding(.bottom)
                
            }
            .navigationTitle("Add an ingredient")
            .listStyle(.plain)
        .padding()
        }
    }
}

struct IngredientCreation_Previews: PreviewProvider {
    static var previews: some View {
        IngredientCreation()
            .preferredColorScheme(.dark)
    }
}