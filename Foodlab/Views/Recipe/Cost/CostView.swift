//
//  CostView.swift
//  Foodlab
//
//  Created by m1 on 04/03/2022.
//

import SwiftUI

struct CostView: View {
    
    @ObservedObject var viewModel: CostDataViewModel
    var intent: CostDataIntent
    var ingredientCost: Double
    var recipeDuration: Int
    var recipeId: Int
    
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
    
    init(viewModel: CostDataViewModel, intent: CostDataIntent, ingredientCost: Double, recipeDuration: Int, recipeId: Int){
        self.viewModel = viewModel
        self.ingredientCost = ingredientCost
        self.recipeDuration = recipeDuration
        self.intent = intent
        self.intent.addObserver(costDataViewModel: viewModel)
        self.recipeId = recipeId
    }
    
    var gridItems = [GridItem(.adaptive(minimum: 150, maximum: 150))]
    var cols = [GridItem(.fixed(250)), GridItem(.flexible())]
    
    var body: some View {
        List {
            VStack {
                LazyVGrid(columns: gridItems,alignment: .leading, spacing: 0){
                    CostFrame(text: "Material cost", value: self.materialCost)
                    CostFrame(text: "Charges cost", value: self.chargesCost)
                    CostFrame(text: "Production cost", value: self.productionCost)
                    CostFrame(text: "Sales prices", value: self.salesPriceWithCharges)
                    CostFrame(text: "Profit", value: self.portionProfit)
                    
                }
                
                LazyVGrid(columns: cols, alignment: .leading, spacing: 15) {
                    Text("Average hourly cost")
                    TextField("Average hourly cost", value: $viewModel.averageHourlyCost, formatter: FormatterHelper.decimalFormatter)
                        .onSubmit {
                            intent.intentToChange(averageHourlyCost: viewModel.averageHourlyCost)
                        }
                    
                    Text("Flatrate hourly cost")
                    TextField("Flatrate hourly cost", value: $viewModel.flatrateHourlyCost, formatter: FormatterHelper.decimalFormatter)
                        .onSubmit {
                            intent.intentToChange(flatrateHourlyCost: viewModel.flatrateHourlyCost)
                        }
                    
                    Text("Coefficient with charges")
                    TextField("Coefficient with charges", value: $viewModel.coefWithCharges, formatter: FormatterHelper.decimalFormatter)
                        .onSubmit {
                            intent.intentToChange(coefWithCharges: viewModel.coefWithCharges)
                        }
                    
                    Text("Coefficient without charges")
                    TextField("Coefficient without charges", value: $viewModel.coefWithoutCharges, formatter: FormatterHelper.decimalFormatter)
                        .onSubmit {
                            intent.intentToChange(coefWithoutCharges: viewModel.coefWithoutCharges)
                        }
                }
                //.padding()
                
                HStack {
                    Spacer()
                    Button("Update cost data") {
                        Task {
                            print(self.recipeId)
                            await intent.intentToUpdate(recipeId: self.recipeId, costData: viewModel.modelCopy)
                        }
                    }
                    .buttonStyle(DarkRedButtonStyle())
                    .padding(.top, 20)
                }
                
            }
        }
    }
}

struct CostView_Previews: PreviewProvider {
    static var previews: some View {
        CostView(viewModel: CostDataViewModel(model: MockData.costData),intent: CostDataIntent(), ingredientCost: 2, recipeDuration: 3, recipeId: 2)
    }
}
