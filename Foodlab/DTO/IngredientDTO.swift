//
//  IngredientDTO.swift
//  Foodlab
//
//  Created by m1 on 16/02/2022.
//

import Foundation

enum StringOrDouble : Codable {
    case post(Double)
    case get(String)
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self{
        case .post(let double):
            try container.encode(double)
        case .get(let string):
            try container.encode(string)
        }
    }
}

struct IngredientDTO: Identifiable, Codable {
    
    var id: Int?
    var name: String
    var unitaryPrice: StringOrDouble
    var stockQuantity: StringOrDouble
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
    init(id: Int? = nil, name: String, unit: String, unitaryPrice: StringOrDouble, stockQuantity: StringOrDouble, ingredientCategoryId: Int, allergenCategoryId: Int? = nil) {
        self.id = id
        self.name = name
        self.unitaryPrice = unitaryPrice
        self.unit = unit
        self.stockQuantity = stockQuantity
        self.ingredientCategoryId = ingredientCategoryId
        self.allergenCategoryId = allergenCategoryId
    }
}
