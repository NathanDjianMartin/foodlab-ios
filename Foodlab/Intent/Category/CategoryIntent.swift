//
//  CategoryIntent.swift
//  Foodlab
//
//  Created by m1 on 03/03/2022.
//

import Combine
import Foundation

enum CategoryIntentState {
    case ready
    case nameChanging(String)
    case categoryUpdatedInDatabase
    case error(String)
}

enum CategoryListIntentState {
    case uptodate
    case addingCategory(Category)
    case deletingCategory(Int)
    case error(String)
}

struct CategoryIntent {
    
    // A subject (publisher) which emits elements to its subscribers
    // IntentState = Output type
    // Never = error type
    // private var formState = PassthroughSubject<CategoryIntentState, Never>()
    private var listState = PassthroughSubject<CategoryListIntentState, Never>()
    var type: CategoryType
    
    func addObserver(categoryListViewModel: CategoryListViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.listState.subscribe(categoryListViewModel)
    }
    /*
    func addObserver(ingredientListViewModel: IngredientListViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.listState.subscribe(ingredientListViewModel)
    }
    */
    
    // MARK: intentToChange functions
    
    
    func intentToCreate(category: Category) async {
        switch await CategoryDAO.createCategory(type: self.type, category: category) {
        case .failure(let error):
            self.listState.send(.error("\(error.localizedDescription)"))
            break
        case .success(let category):
            self.listState.send(.addingCategory(category))
        }
    }
    
    func intentToDelete(categoryId id: Int, categoryIndex: Int) async {
        switch await CategoryDAO.deleteCategoryById(id) {
        case .failure(let error):
            self.listState.send(.error("Error while deleting category \(id): \(error.localizedDescription)"))
        case .success:
            self.listState.send(.deletingCategory(categoryIndex))
        }
    }
    
    func intentToChange(name: String, unit: String, unitaryPrice: Double, stockQuantity: Double, ingredientCategory: Category, allergenCategory: Category?) {
        self.formState.send(.nameChanging(name))
        self.formState.send(.unitChanging(unit))
        self.formState.send(.unitaryPriceChanging(unitaryPrice))
        self.formState.send(.stockQuantityChanging(stockQuantity))
        self.formState.send(.ingredientCategoryChanging(ingredientCategory))
        self.formState.send(.allergenCategoryChanging(allergenCategory))
    }
}
