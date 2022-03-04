//
//  CostView.swift
//  Foodlab
//
//  Created by m1 on 04/03/2022.
//

import SwiftUI

struct CostView: View {
    
    @ObservedObject var viewModel: CostDataViewModel
    var recipeId: Int
    var ingredientCost: Double
    var materialCost: Double
    var salesPricesWithoutCharges: Double
    var recipeDuration: Int
    var staffCost: Double
    var fluidCost: Double
    var chargesCost: Double
    var productionCost: Double
    var salesPriceWithCharges: Double
    var portionProfit: Double 
    
    init(viewModel: CostDataViewModel, recipeId: Int) async {
        self.viewModel = viewModel
        self.recipeId = recipeId
    }
    
    var gridItems = [GridItem(.adaptive(minimum: 100))]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems,spacing: 0){
                VStack {
                    Text("Material cost")
                    Text("")
                }
            }.onAppear {
                Task {
                    switch await RecipeDAO.shared.getIngredientCost(recipeId: recipeId) {
                    case .failure(let error):
                        print(error)
                    case .success(let cost):
                        ingredientCost = cost
                    }
                    switch await RecipeDAO.shared.getRecipeDuration(recipeId: recipeId) {
                    case .failure(let error):
                        print(error)
                    case .success(let duration):
                         recipeDuration = duration
                    }
                }
            }
                    
        }
    }
}

struct CostView_Previews: PreviewProvider {
    static var previews: some View {
        CostView(viewModel: CostDataViewModel(model: MockData.costData))
    }
}
