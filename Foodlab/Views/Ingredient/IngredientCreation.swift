//
//  IngredientCreation.swift
//  Foodlab
//
//  Created by Nathan Djian Martin on 02/02/2022.
//

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
    
    private var columns = [GridItem](repeating: GridItem(.adaptive(minimum: 100)), count: 2)
    
    var body: some View {
        VStack {
            Text("Add an ingredient")
                .font(.title)
                .fontWeight(.bold)
            
            
            HStack {
                Text("Name")
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            
            HStack {
                Text("Unit")
                TextField("Unit", text: $unit)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
                Text("Price")
                TextField("Price", value: $price, formatter: decimalFormatter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
                Text("Stock quantity")
                TextField("Stock quantity", value: $stockQuantity, formatter: decimalFormatter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Dropdown(placeholder: "Ingredient category", dropDownList: MockData.ingredientCategories)
            Dropdown(placeholder: "Allergen category", dropDownList: MockData.allergenCategories)
            
            HStack {
                Spacer()
                Button("Create ingredient") {
                    print("TODO: Create ingredient!")
                }
                .padding(10)
                .background(Color.darkRed)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct IngredientCreation_Previews: PreviewProvider {
    static var previews: some View {
        IngredientCreation()
    }
}
