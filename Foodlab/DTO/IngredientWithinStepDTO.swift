//
//  IngredientWithinStepDTO.swift
//  Foodlab
//
//  Created by m1 on 26/02/2022.
//

import Foundation

struct IngredientWithinStepDTO: Identifiable, Codable {
    
    var id: Int?
    var ingredientId: Int
    var stepId: Int
    var quantity: StringOrDouble
    
    init(id: Int? = nil, ingredientId: Int, stepId: Int, quantity: StringOrDouble) {
        self.id = id
        self.ingredientId = ingredientId
        self.stepId = stepId
        self.quantity = quantity
    }
}
