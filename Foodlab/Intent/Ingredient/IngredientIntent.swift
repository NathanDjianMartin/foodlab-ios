//
//  IngredientIntent.swift
//  Foodlab
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import Combine

enum IngredientFormIntentState {
    case ready
    case nameChanging(String)
    case unitChanging(String)
    case unitaryPriceChanging(Double)
    case stockQuantityChanging(Double)
    case ingredientCategoryChanging(Category)
    case allergenCategoryChanging(Category?)
    case ingredientUpdatedInDatabase
    
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
            return "state: allergenCategoryChanging(\(String(describing: allergenCategory))"
        case .ingredientUpdatedInDatabase:
            return "state: ingredientUpdatedInDatabase"
        }
    }
}

enum IngredientListIntentState {
    case uptodate
    //case needToBeUpdated
    case addingIngredient(Ingredient)
}

struct IngredientIntent {
    
    // A subject (publisher) which emits elements to its subscribers
    // IntentState = Output type
    // Never = error type
    private var formState = PassthroughSubject<IngredientFormIntentState, Never>()
    private var listState = PassthroughSubject<IngredientListIntentState, Never>()
    
    func addObserver(ingredientFormViewModel: IngredientFormViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.formState.subscribe(ingredientFormViewModel)
    }
    
    func addObserver(ingredientListViewModel: IngredientListViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.listState.subscribe(ingredientListViewModel)
    }
    
    // MARK: intentToChange functions
    
    func intentToChange(name: String) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.nameChanging(name)) // emits an object of type IntentState
    }
    
    func intentToChange(unit: String) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.unitChanging(unit)) // emits an object of type IntentState
    }
    
    func intentToChange(unitaryPrice: Double) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.unitaryPriceChanging(unitaryPrice)) // emits an object of type IntentState
    }
    
    func intentToChange(stockQuantity: Double) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.stockQuantityChanging(stockQuantity)) // emits an object of type IntentState
    }
    
    func intentToChange(ingredientCategory: Category) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.ingredientCategoryChanging(ingredientCategory)) // emits an object of type IntentState
    }
    
    func intentToChange(allergenCategory: Category) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.allergenCategoryChanging(allergenCategory)) // emits an object of type IntentState
    }
    
    func intentToUpdate(ingredient: Ingredient) async {
        switch await IngredientDAO.updateIngredient(ingredient: ingredient) {
        case .failure(let error):
            //TODO: gérer
            print("Error while intenting to update ingredien  \(error)")
            break
        case .success(let ingredient):
            // si ça a marché : modifier le view model et le model
            self.formState.send(.ingredientUpdatedInDatabase)
//            self.listState.send(.needToBeUpdated)
        }
    }
    
    func intentToCreate(ingredient: Ingredient) async {
        switch await IngredientDAO.createIngredient(ingredient: ingredient) {
        case .failure(let error):
            //TODO: gérer
            break
        case .success(let ingredient):
            // si ça a marché : modifier le view model et le model
            self.formState.send(.ingredientUpdatedInDatabase)
            self.listState.send(.addingIngredient(ingredient))
//            self.listState.send(.needToBeUpdated)
        }
    }
    
    func intentToChange(name: String, unit: String, unitaryPrice: Double, stockQuantity: Double, ingredientCategory: Category, allergenCategory: Category?) {
        self.formState.send(.nameChanging(name))
        self.formState.send(.unitChanging(unit))
        self.formState.send(.unitaryPriceChanging(unitaryPrice))
        self.formState.send(.stockQuantityChanging(stockQuantity))
        self.formState.send(.ingredientCategoryChanging(ingredientCategory))
        self.formState.send(.allergenCategoryChanging(allergenCategory))
//        self.listState.send(.needToBeUpdated)
        
    }
}
