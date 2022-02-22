//
//  IngredientInRecipeList.swift
//  Foodlab
//
//  Created by m1 on 20/02/2022.
//

import SwiftUI

struct IngredientInRecipeList: View {
    var ingredients: [Ingredient: Double]?
    
    var body: some View {
        List {
            if let ingredients = ingredients {
                ForEach(ingredients.sorted(by: >), id: \.key) { key, value in
                    HStack {
                        Text("\(key.name)")
                        Spacer()
                        Text("\(value)\(key.unit)")
                    }
                }
            }
        }
    }
}

struct IngredientInRecipeList_Previews: PreviewProvider {
    static var previews: some View {
        IngredientInRecipeList(ingredients: MockData.step.ingredients)
    }
}
