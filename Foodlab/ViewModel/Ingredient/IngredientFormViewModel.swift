//
//  IngredientFormViewModel.swift
//  Foodlab
//
//  Created by m1 on 19/02/2022.
//

import Combine
import Foundation

enum InputIngredientError: Error {
    case UnitaryPriceInputError(String)
    case StockQuantityInputError(String)
}

class IngredientFormViewModel : ObservableObject, Subscriber, IngredientObserver {
    
    private var model: Ingredient
    // save model in case the modification is cancelled
    private (set) var modelCopy: Ingredient
    
    var id: Int?
    @Published var name: String
    @Published var unit: String
    @Published var unitaryPrice: Double
    @Published var stockQuantity: Double
    @Published var ingredientCategory: Category
    @Published var allergenCategory: Category?
    
    init(model: Ingredient) {
        self.id = model.id
        self.name = model.name
        self.unit = model.unit
        self.unitaryPrice = model.unitaryPrice
        self.stockQuantity = model.stockQuantity
        self.ingredientCategory = model.ingredientCategory
        self.allergenCategory = model.allergenCategory
        self.model = model
        self.modelCopy = model.copy()
        self.model.addObserver(self)
    }
    
    // MARK: -
    // MARK: Track observer delegate functions
    
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
        self.ingredientCategory = ingredientCategory
    }
    
    func changed(allergenCategory: Category?) {
        self.allergenCategory = allergenCategory
    }
    
    // MARK: -
    // MARK: Subscriber conformance
    
    typealias Input = IntentIngredientState
    typealias Failure = Never
    
    // Called by Subscriber protocol during subscription
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    // Called if the publisher says it finished emitting (doesn't concern us)
    func receive(completion: Subscribers.Completion<Failure>) {
        return
    }
    
    // Called each time the publisher calls the "send" method to notify about state modification
    func receive(_ input: IntentIngredientState) -> Subscribers.Demand {
        print("vm -> intent \(input)")
        switch input{
        case .ready:
            break
        case .nameChanging(let name):
            let nameClean = name.trimmingCharacters(in: .whitespacesAndNewlines)
            print("vm: change ingredient name to '\(nameClean)'")
            self.modelCopy.name = nameClean
            print("vm: ingredient name changed to '\(self.model.name)'")
        case .unitChanging(let unit):
            let unitClean = unit.trimmingCharacters(in: .whitespacesAndNewlines)
            print("vm: change ingridient unit to '\(unitClean)'")
            self.modelCopy.unit = unitClean
            print("vm: ingredient unit changed to '\(self.model.unit)'")
        case .unitaryPriceChanging(let unitaryPrice):
            let unitaryPriceClean = Double(unitaryPrice)
            print("vm: change ingredient unitary price to '\(unitaryPriceClean)'")
            self.modelCopy.unitaryPrice = unitaryPriceClean
            print("vm: ingredient unitary price changed to '\(self.model.unitaryPrice)'")
        case .stockQuantityChanging(let stockQuantity):
            let stockQuantityClean = Double(stockQuantity)
            print("vm: change ingredient stock quantity to '\(stockQuantityClean)'")
            self.modelCopy.stockQuantity = stockQuantityClean
            print("vm: ingredient stock quantity changed to '\(self.model.stockQuantity)'")
        case .ingredientCategoryChanging(let ingredientCategory):
            print("vm: change ingredient category to '\(ingredientCategory.name)'")
            self.modelCopy.ingredientCategory = ingredientCategory
            print("vm: ingredient category changed to '\(self.model.ingredientCategory)'")
        case .allergenCategoryChanging(let allergenCategory):
            self.modelCopy.allergenCategory = allergenCategory
        case .ingredientUpdatedInDatabase :
            self.model.name = self.modelCopy.name
            self.model.unit = self.modelCopy.unit
            self.model.unitaryPrice = self.modelCopy.unitaryPrice
            self.model.stockQuantity = self.modelCopy.stockQuantity
            self.model.ingredientCategory = self.modelCopy.ingredientCategory
            self.model.allergenCategory = self.modelCopy.allergenCategory
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
