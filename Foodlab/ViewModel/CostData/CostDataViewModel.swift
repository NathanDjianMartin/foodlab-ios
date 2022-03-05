//
//  CostDataViewModel.swift
//  Foodlab
//
//  Created by m1 on 04/03/2022.
//

import Combine
import Foundation

class CostDataViewModel : ObservableObject, Subscriber, CostDataObserver {    
    
    var model: CostData {
        didSet {
            self.modelCopy = CostData(id: model.id, averageHourlyCost: model.averageHourlyCost, flatrateHourlyCost: model.flatrateHourlyCost, coefWithCharges: model.coefWithCharges, coefWithoutCharges: model.coefWithoutCharges)
            self.averageHourlyCost = model.averageHourlyCost
            self.flatrateHourlyCost = model.flatrateHourlyCost
            self.coefWithCharges = model.coefWithCharges
            self.coefWithoutCharges = model.coefWithoutCharges
        }
    }
    // save model in case the modification is cancelled
    private (set) var modelCopy: CostData
    
    var id: Int?
    @Published var averageHourlyCost: Double
    @Published var flatrateHourlyCost: Double
    @Published var coefWithCharges: Double
    @Published var coefWithoutCharges: Double
    @Published var error: String?
    
    init(model: CostData = CostData(averageHourlyCost: 0, flatrateHourlyCost: 0, coefWithCharges: 0, coefWithoutCharges: 0)) {
        self.id = model.id
        self.averageHourlyCost = model.averageHourlyCost
        self.flatrateHourlyCost = model.flatrateHourlyCost
        self.coefWithCharges = model.coefWithCharges
        self.coefWithoutCharges = model.coefWithoutCharges
        self.model = model
        self.modelCopy = CostData(id: model.id, averageHourlyCost: model.averageHourlyCost, flatrateHourlyCost: model.flatrateHourlyCost, coefWithCharges: model.coefWithCharges, coefWithoutCharges: model.coefWithoutCharges)
        self.model.observer = self
    }
    
    // MARK: -
    // MARK: Track observer delegate functions
    
    func changed(averageHourlyCost: Double) {
        self.averageHourlyCost = averageHourlyCost
    }
    
    func changed(flatrateHourlyCost: Double) {
        self.flatrateHourlyCost = flatrateHourlyCost
    }
    
    func changed(coefWithCharges: Double) {
        self.coefWithCharges = coefWithCharges
    }
    
    func changed(coefWithoutCharges: Double) {
        self.coefWithoutCharges = coefWithoutCharges
    }
    
    // MARK: -
    // MARK: Subscriber conformance
    
    typealias Input = CostDataIntentState
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
    func receive(_ input: CostDataIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .averageHourlyCostChanging(let averageHourlyCost):
            self.modelCopy.averageHourlyCost = averageHourlyCost
        case .flatrateHourlyCostChanging(let flatrateHourlyCost):
            self.modelCopy.flatrateHourlyCost = flatrateHourlyCost
        case .coefWithChargesChanging(let coefWithCharges):
            self.modelCopy.coefWithCharges = coefWithCharges
        case .coefWithoutChargesChanging(let coefWithCharges):
            self.modelCopy.coefWithCharges = coefWithCharges
        case .costDataUpdatedInDatabase:
            self.model.averageHourlyCost = self.modelCopy.averageHourlyCost
            self.model.flatrateHourlyCost = self.modelCopy.flatrateHourlyCost
            self.model.coefWithCharges = self.modelCopy.coefWithCharges
            self.model.coefWithoutCharges = self.modelCopy.coefWithoutCharges
        case .error(let errorMessage):
            self.error = errorMessage
        }
        
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
