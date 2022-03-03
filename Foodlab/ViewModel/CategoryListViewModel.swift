//
//  CategoryViewModel.swift
//  Foodlab
//
//  Created by m1 on 03/03/2022.
//

import Combine
import Foundation

class CategoryListViewModel : ObservableObject, Subscriber {
    
    @Published var categories: [Category]
    @Published var error: String?
    var type: CategoryType
    
    init(categories: [Category] = [], type: CategoryType) {
        self.type = type
        self.categories = categories
    }
    
    // MARK: -
    // MARK: Subscriber conformance
    
    typealias Input = CategoryListIntentState
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
    func receive(_ input: CategoryListIntentState) -> Subscribers.Demand {
        switch input {
        case .uptodate:
            break
        case .addingCategory(let category):
            self.categories.append(category)
        case .deletingCategory(let categoryIndex):
            let category = self.categories.remove(at: categoryIndex)
            print("Deleting \(category.name) of index \(categoryIndex)")
        case .error(let errorMessage):
            self.error = errorMessage
        }
        
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
