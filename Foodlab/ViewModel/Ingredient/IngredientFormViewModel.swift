//
//  IngredientFormViewModel.swift
//  Foodlab
//
//  Created by m1 on 19/02/2022.
//

import Combine
import Foundation

class IngredientFormViewModel : ObservableObject, Subscribers, IngredientObserver {
    
    private var model: Ingredient
    @Published var name: String
    @Published var unit: String
    @Published var unitaryPrice: Double
    @Published var stockQuantity: Double
    @Published var ingredientCategory: Category
    @Published var allergenCategory: Category?
    
    init(model: Ingredient) {
        self.name = model.name
        self.unit = model.unit
        self.unitaryPrice = model.unitaryPrice
        self.stockQuantity = model.stockQuantity
        self.ingredientCategory = model.ingredientCategory
        self.allergenCategory = model.allergenCategory
        self.model = model
        self.model.observer = self
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
    
    func changed(allergenCategory: Category) {
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
        case .trackNameChanging(let name):
            let nameClean = name.trimmingCharacters(in: .whitespacesAndNewlines)
            print("vm: change track name to '\(nameClean)'")
            self.model.trackName = nameClean
            print("vm: track name changed to '\(self.model.trackName)'")
        case .artistNameChanging(let name):
            let nameClean = name.trimmingCharacters(in: .whitespacesAndNewlines)
            print("vm: change artist name to '\(nameClean)'")
            self.model.artistName = nameClean
            print("vm: track artist changed to '\(self.model.artistName)'")
        case .collectionNameChanging(let name):
            let nameClean = name.trimmingCharacters(in: .whitespacesAndNewlines)
            print("vm: change collection name to '\(nameClean)'")
            self.model.collectionName = nameClean
            print("vm: track collection changed to '\(self.model.collectionName)'")
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}

}
