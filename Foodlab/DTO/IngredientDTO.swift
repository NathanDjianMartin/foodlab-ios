//
//  IngredientDTO.swift
//  Foodlab
//
//  Created by m1 on 16/02/2022.
//

import Foundation

struct IngredientDTO: Identifiable, Decodable {
    
    var id: Int?
    var name: String
    var unitaryPrice: String
    var stockQuantity: String
    var unit: String
    var ingredientCategoryId: Int
    var allergenCategoryId: Int?
    /*
    {
           "id": 30,
           "name": "Crevettes",
           "unitaryPrice": "17.61",
           "stockQuantity": "3.8",
           "unit": "Kg",
           "ingredientCategoryId": 19,
           "allergenCategoryId": 15,
           
       },
    */
    init(id: Int? = nil, name: String, unitaryPrice: String, unit: String, stockQuantity: String, ingredientCategoryId: Int, allergenCategoryId: Int? = nil) {
        self.id = id
        self.name = name
        self.unitaryPrice = unitaryPrice
        self.unit = unit
        self.stockQuantity = stockQuantity
        self.ingredientCategoryId = ingredientCategoryId
        self.allergenCategoryId = allergenCategoryId
    }
}
