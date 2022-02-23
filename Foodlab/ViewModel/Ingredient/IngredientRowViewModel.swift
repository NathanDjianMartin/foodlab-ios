//
//  IngredientRowViewModel.swift
//  Foodlab
//
//  Created by m1 on 23/02/2022.
//

import Foundation

class IngredientRowViewModel : ObservableObject, IngredientObserver {
    
    private var model: Ingredient
    // save model in case the modification is cancelled
    
    @Published var name: String
    @Published var unit: String
    @Published var unitaryPrice: Double
    @Published var stockQuantity: Double
    
    init(model: Ingredient) {
        self.name = model.name
        self.unit = model.unit
        self.unitaryPrice = model.unitaryPrice
        self.stockQuantity = model.stockQuantity
        self.model = model
        self.model.addObserver(self)
    }
    
    // MARK: -
    // MARK: Ingredient observer delegate functions
    
    func changed(name: String) {
        self.name = name
    }
    
    func changed(unit: String) {
        self.unit = unit
    }
    
    func changed(unitaryPrice: Double) {
        self.unitaryPrice = unitaryPrice
    }
    
    func changed(stockQuantity: Double) {
        self.stockQuantity = stockQuantity
    }
    
    func changed(ingredientCategory: Category) {
        return
    }
    
    func changed(allergenCategory: Category?) {
        return
    }
    
}
