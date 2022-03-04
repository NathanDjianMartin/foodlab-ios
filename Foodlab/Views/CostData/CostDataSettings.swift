//
//  CostDataSettings.swift
//  Foodlab
//
//  Created by m1 on 15/02/2022.
//

import SwiftUI

struct CostDataSettings: View {
    
    @ObservedObject var viewModel: CostDataViewModel
    private var intent: CostDataIntent
    
    init(viewModel: CostDataViewModel, intent: CostDataIntent){
        self.viewModel = viewModel
        self.intent = intent
        self.intent.addObserver(costDataViewModel: viewModel)
    }
    
    var cols = [GridItem(.fixed(250)), GridItem(.flexible())]
    
    var body: some View {
        ErrorView(error: $viewModel.error)
        
        List {
            LazyVGrid(columns: cols, alignment: .leading, spacing: 15) {
                Text("Average hourly cost")
                TextField("Name", value: $viewModel.averageHourlyCost, formatter: FormatterHelper.decimalFormatter)
                    .onSubmit {
                        intent.intentToChange(averageHourlyCost: viewModel.averageHourlyCost)
                    }
           
                Text("Flatrate hourly cost")
                TextField("Email", value: $viewModel.flatrateHourlyCost, formatter: FormatterHelper.decimalFormatter)
                    .onSubmit {
                        intent.intentToChange(flatrateHourlyCost: viewModel.flatrateHourlyCost)
                    }
           
                Text("Coefficient with charges")
                TextField("Password", value: $viewModel.coefWithCharges, formatter: FormatterHelper.decimalFormatter)
                    .onSubmit {
                        intent.intentToChange(coefWithCharges: viewModel.coefWithCharges)
                    }
            
                Text("Coefficient without charges")
                TextField("Password", value: $viewModel.coefWithoutCharges, formatter: FormatterHelper.decimalFormatter)
                    .onSubmit {
                        intent.intentToChange(coefWithoutCharges: viewModel.coefWithoutCharges)
                    }
            }
            //.padding()
                    
            HStack {
                Spacer()
                Button("Update cost data") {
                    Task {
                        await intent.intentToUpdateDefaultCostData(costData: viewModel.modelCopy)
                    }
                }
                .buttonStyle(DarkRedButtonStyle())
                .padding(.top, 20)
            }
        }
        .navigationTitle("Default cost data")
        .listStyle(.plain)
        .padding()
    }
}

struct CostDataSettings_Previews: PreviewProvider {
    static var previews: some View {
        CostDataSettings(viewModel: CostDataViewModel(model: MockData.costData), intent: CostDataIntent())
    }
}
