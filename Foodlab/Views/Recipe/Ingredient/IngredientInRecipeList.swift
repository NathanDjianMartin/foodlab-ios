//
//  IngredientInRecipeList.swift
//  Foodlab
//
//  Created by m1 on 20/02/2022.
//

import SwiftUI

struct IngredientInRecipeList: View {
    var ingredients: [IngredientWithinStep]?
    
    var body: some View {
        List {
            if let ingredients = ingredients {
                ForEach(ingredients) { ingredient in
                    HStack {
                        Text("\(ingredient.ingredient.name)")
                        Spacer()
                        Text("\(ingredient.quantity)\(ingredient.ingredient.unit)")
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
