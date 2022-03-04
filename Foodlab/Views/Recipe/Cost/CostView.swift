//
//  CostView.swift
//  Foodlab
//
//  Created by m1 on 04/03/2022.
//

import SwiftUI

struct CostView: View {
    
    @ObservedObject var viewModel: CostDataViewModel
    var ingredientCost: Double
    var recipeDuration: Int
    
    var materialCost: Double {
        ingredientCost + (ingredientCost * 0.05)
    }
    var salesPricesWithoutCharges: Double {
        materialCost * viewModel.coefWithoutCharges
    }
    var staffCost: Double {
        (Double(recipeDuration)/60) * viewModel.averageHourlyCost
    }
    var fluidCost: Double {
        (Double(recipeDuration)/60) * viewModel.flatrateHourlyCost
    }
    var chargesCost: Double {
        staffCost + fluidCost
    }
    var productionCost: Double {
        materialCost + chargesCost
    }
    var salesPriceWithCharges: Double {
        productionCost * viewModel.coefWithCharges
    }
    var portionProfit: Double {
        salesPriceWithCharges - productionCost
    }
    
    init(viewModel: CostDataViewModel, ingredientCost: Double, recipeDuration: Int){
        self.viewModel = viewModel
        self.ingredientCost = ingredientCost
        self.recipeDuration = recipeDuration
    }
    
    var gridItems = [GridItem(.adaptive(minimum: 150, maximum: 150))]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems,spacing: 0){
                CostFrame(text: "Material cost", value: self.materialCost)
                CostFrame(text: "Charges cost", value: self.chargesCost)
                CostFrame(text: "Production cost", value: self.productionCost)
                CostFrame(text: "Sales prices", value: self.salesPriceWithCharges)
                CostFrame(text: "Profit", value: self.portionProfit)
                
            }
        }
    }
}

struct CostView_Previews: PreviewProvider {
    static var previews: some View {
        CostView(viewModel: CostDataViewModel(model: MockData.costData), ingredientCost: 2, recipeDuration: 3)
    }
}
