//
//  IngredientWithinStep.swift
//  Foodlab
//
//  Created by m1 on 20/02/2022.
//

import Foundation

class IngredientWithinStep: Identifiable {
    var id: Int?
    var ingredient: Ingredient
    var quantity: Double
    
    init(id: Int? = nil, ingredient: Ingredient, quantity: Double) {
        self.id = id
        self.ingredient = ingredient
        self.quantity = quantity
    }
    
}
