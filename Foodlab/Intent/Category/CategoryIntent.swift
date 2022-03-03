//
//  CategoryIntent.swift
//  Foodlab
//
//  Created by m1 on 03/03/2022.
//

import Combine
import Foundation
/*
enum CategoryIntentState {
    case ready
    case nameChanging(String)
    case categoryUpdatedInDatabase
    case error(String)
}
*/
enum CategoryIntentState {
    case uptodate
    case addingCategory(Category)
    case deletingCategory(Int)
    case error(String)
}
/*
struct CategoryIntent {
    
    // A subject (publisher) which emits elements to its subscribers
    // IntentState = Output type
    // Never = error type
    // private var formState = PassthroughSubject<CategoryIntentState, Never>()
    private var listState = PassthroughSubject<CategoryIntentState, Never>()
    var type: CategoryType
    
    func addObserver(categoryViewModel: CategoryViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.listState.subscribe(categoryViewModel)
    }
    /*
    func addObserver(ingredientListViewModel: IngredientListViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.listState.subscribe(ingredientListViewModel)
    }
    */
    
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
        switch await CategoryDAO.deleteCategoryById(type: self.type, id: id) {
        case .failure(let error):
            self.listState.send(.error("Error while deleting category \(id): \(error.localizedDescription)"))
        case .success:
            self.listState.send(.deletingCategory(categoryIndex))
        }
    }
    
}
*/
