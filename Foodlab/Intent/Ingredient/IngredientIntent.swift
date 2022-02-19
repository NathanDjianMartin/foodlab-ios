//
//  IngredientIntent.swift
//  Foodlab
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import Combine

enum IntentIngredientState {
    case ready
    case nameChanging(String)
    case unitChanging(String)
    case unitaryPriceChanging(Double)
    case stockQuantityChanging(Double)
    case ingredientCategoryChanging(Category)
    case allergenCategoryChanging(Category)
    
    var description: String {
        switch self {
        case .ready:
            return "state: ready"
        case .nameChanging(let name):
            return "state: trackNameChaging(\(name)"
        case .unitChanging(let unit):
            return "state: unitChanging(\(unit)"
        case .unitaryPriceChanging(let unitaryPrice):
            return "state: unitaryPriceChanging(\(unitaryPrice)"
        case .stockQuantityChanging(let stockQuantity):
            return "state: stockQuantityChanging(\(stockQuantity)"
        case .ingredientCategoryChanging(let ingredientCategory):
            return "state: ingredientCategoryChanging(\(ingredientCategory)"
        case .allergenCategoryChanging(let allergenCategory):
            return "state: allergenCategoryChanging(\(allergenCategory)"
        }
    }
}

enum IntentIngredientListState {
    case uptodate
    case needToBeUpdated
   
}

struct IngredientIntent {
    
    // A subject (publisher) which emits elements to its subscribers
    // IntentState = Output type
    // Never = error type
    private var state = PassthroughSubject<IntentIngredientState, Never>()
    private var listState = PassthroughSubject<IntentIngredientListState, Never>()
    
    func addObserver(ingredientFormViewModel: IngredientFormViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.state.subscribe(ingredientFormViewModel)
    }
    
    func addObserver(ingredientListViewModel: IngredientListViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.listState.subscribe(ingredientListViewModel)
    }
    
    // MARK: intentToChange functions
    
    func intentToChange(name: String) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.state.send(.nameChanging(name)) // emits an object of type IntentState
        self.listState.send(.needToBeUpdated)
    }
    
    func intentToChange(unit: String) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.state.send(.unitChanging(unit)) // emits an object of type IntentState
        self.listState.send(.needToBeUpdated)
    }
    
    func intentToChange(unitaryPrice: Double) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.state.send(.unitaryPriceChanging(unitaryPrice)) // emits an object of type IntentState
        self.listState.send(.needToBeUpdated)
    }
    
    func intentToChange(stockQuantity: Double) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.state.send(.stockQuantityChanging(stockQuantity)) // emits an object of type IntentState
        self.listState.send(.needToBeUpdated)
    }
    
    func intentToChange(ingredientCategory: Category) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.state.send(.ingredientCategoryChanging(ingredientCategory)) // emits an object of type IntentState
        self.listState.send(.needToBeUpdated)
    }
    
    func intentToChange(allergenCategory: Category) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.state.send(.allergenCategoryChanging(allergenCategory)) // emits an object of type IntentState
        self.listState.send(.needToBeUpdated)
    }
}
