//
//  IngredientDTO.swift
//  Foodlab
//
//  Created by m1 on 16/02/2022.
//

import Foundation

struct IngredientDTO: Identifiable {
    
    var id: Int?
    var name: String
    var unit: String
    var price: Double
    var stockQuantity: Double
    var ingredientCategoryId: Int
    var allergenCategoryId: Int?
    
    init(id: Int? = nil, name: String, unit: String, price: Double, stockQuantity: Double, ingredientCategoryId: Int, allergenCategoryId: Int? = nil) {
        self.id = id
        self.name = name
        self.unit = unit
        self.price = price
        self.stockQuantity = stockQuantity
        self.ingredientCategoryId = ingredientCategoryId
        self.allergenCategoryId = allergenCategoryId
    }
}
