//
//  IngredientList.swift
//  Foodlab
//
//  Created by m1 on 05/03/2022.
//

import SwiftUI

struct IngredientListInStep: View {
    var ingredients: [Ingredient: Double]?
    
    var body: some View {
        List {
            if let ingredients = ingredients {
                ForEach(ingredients.sorted(by: >), id: \.key) { key, value in
                    HStack {
                        Text("\(key.name)")
                        Spacer()
                        Text("\(value) \(key.unit)")
                    }
                }
            } else {
                Text("There are no ingredient in this step")
            }
        }
        
    }
}

struct IngredientList_Previews: PreviewProvider {
    static var previews: some View {
        IngredientList()
    }
}
