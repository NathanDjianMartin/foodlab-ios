//
//  CostDataIntent.swift
//  Foodlab
//
//  Created by m1 on 04/03/2022.
//

import Combine
import Foundation

enum CostDataIntentState {
    case ready
    case averageHourlyCostChanging(Double)
    case flatrateHourlyCostChanging(Double)
    case coefWithChargesChanging(Double)
    case coefWithoutChargesChanging(Double)
    case costDataUpdatedInDatabase
    case error(String)
}

struct CostDataIntent {
    
    // A subject (publisher) which emits elements to its subscribers
    // IntentState = Output type
    // Never = error type
    private var formState = PassthroughSubject<CostDataIntentState, Never>()
    
    func addObserver(costDataViewModel: CostDataViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.formState.subscribe(costDataViewModel)
    }
    
    // MARK: intentToChange functions
    
    func intentToChange(averageHourlyCost: Double) {
        self.formState.send(.averageHourlyCostChanging(averageHourlyCost))
    }
    
    func intentToChange(flatrateHourlyCost: Double) {
        self.formState.send(.flatrateHourlyCostChanging(flatrateHourlyCost))
    }
    
    func intentToChange(coefWithCharges: Double) {
        self.formState.send(.coefWithChargesChanging(coefWithCharges))
    }
    
    func intentToChange(coefWithoutCharges: Double) {
        self.formState.send(.coefWithoutChargesChanging(coefWithoutCharges))
    }
    
    func intentToUpdate(recipeId: Int, costData: CostData) async {
        switch await CostDataDAO.shared.updateCostData(recipeId: recipeId, costData: costData) {
        case .failure(let error):
            self.formState.send(.error("\(error.localizedDescription)"))
        case .success:
            // si ça a marché : modifier le view model et le model
            self.formState.send(.costDataUpdatedInDatabase)
        }
    }
    
    func intentToUpdateDefaultCostData(costData: CostData) async {
        switch await CostDataDAO.shared.updateDefaultCostData(costData: costData) {
        case .failure(let error):
            self.formState.send(.error("\(error.localizedDescription)"))
        case .success:
            // si ça a marché : modifier le view model et le model
            self.formState.send(.costDataUpdatedInDatabase)
        }
    }
    
}
