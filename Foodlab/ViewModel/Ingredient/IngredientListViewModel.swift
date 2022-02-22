//
//  IngredientListViewModel.swift
//  Foodlab
//
//  Created by m1 on 19/02/2022.
//

import Combine
import Foundation

class IngredientListViewModel: ObservableObject, Subscriber {
    
    public var ingredients : [Ingredient]
    
    init(ingredients: [Ingredient] = []) {
        self.ingredients = ingredients
    }
    
    // MARK: -
    // MARK: Subscriber conformance
    
    typealias Input = IntentIngredientListState
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
    func receive(_ input: IntentIngredientListState) -> Subscribers.Demand {
        print("vm -> intent \(input)")
        switch input{
        case .uptodate:
            break
        case .needToBeUpdated:
            self.objectWillChange.send()
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
