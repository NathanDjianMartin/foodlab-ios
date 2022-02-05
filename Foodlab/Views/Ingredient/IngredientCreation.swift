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
        ScrollView {
            VStack {
                Text("Add an ingredient")
                    .font(.title)
                    .fontWeight(.bold)
                
                
                HStack {
                    Text("Name")
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedTextFieldStyle())
                }
                
                LazyVGrid(columns: columns) {
                    HStack {
                        Text("Unit")
                        TextField("Unit", text: $unit)
                            .textFieldStyle(RoundedTextFieldStyle())
                    }
                    
                    HStack {
                        Text("Price")
                        TextField("Price", value: $price, formatter: decimalFormatter)
                            .textFieldStyle(RoundedTextFieldStyle())
                    }
                    
                    HStack {
                        Text("Stock quantity")
                            .lineLimit(1)
                        TextField("Stock quantity", value: $stockQuantity, formatter: decimalFormatter)
                            .textFieldStyle(RoundedTextFieldStyle())
                    }
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
                
                Spacer()
            }
            .padding()
        }
        .background(Color("BackgroundColor"))
    }
}

struct IngredientCreation_Previews: PreviewProvider {
    static var previews: some View {
        IngredientCreation()
            .preferredColorScheme(.dark)
    }
}
