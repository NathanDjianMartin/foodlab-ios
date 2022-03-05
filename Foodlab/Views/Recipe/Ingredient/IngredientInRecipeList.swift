//
//  IngredientInRecipeList.swift
//  Foodlab
//
//  Created by m1 on 20/02/2022.
//

import SwiftUI

struct IngredientInRecipeList: View {
    var recipeExecution: RecipeExecution?
    
    var body: some View {
        
        VStack {
            List {
                if let recipeExecution = self.recipeExecution {
                    ForEach(recipeExecution.steps) { step in
                        if let simpleStep = step as? SimpleStep {
                            if let ingredients = simpleStep.ingredients {
                                ForEach(ingredients.sorted(by: >), id: \.key) { key, value in
                                    HStack {
                                        Text("\(key.name)")
                                        Spacer()
                                        Text("\(value) \(key.unit)")
                                    }
                                }
                            }
                        } else if let recipeExecution = step as? RecipeExecution {
                            ForEach(recipeExecution.steps) { step in
                                if let simpleStep = step as? SimpleStep {
                                    if let ingredients = simpleStep.ingredients {
                                        ForEach(ingredients.sorted(by: >), id: \.key) { key, value in
                                            HStack {
                                                Text("\(key.name)")
                                                Spacer()
                                                Text("\(value) \(key.unit)")
                                            }
                                        }
                                    }
                                } else if let recipeExecution = step as? RecipeExecution {
                                    IngredientInRecipeList(recipeExecution: recipeExecution)
                                }
                            }
                        }
                    }
                    
                } else {
                    Text("There are no ingredient in this recipe")
                }
            }
        }
    }
}

struct IngredientInRecipeList_Previews: PreviewProvider {
    static var previews: some View {
        IngredientInRecipeList(recipeExecution: MockData.recipePates.execution)
    }
}
