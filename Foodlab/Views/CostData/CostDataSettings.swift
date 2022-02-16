//
//  CostDataSettings.swift
//  Foodlab
//
//  Created by m1 on 15/02/2022.
//

import SwiftUI

struct CostDataSettings: View {
    //TODO : changer variables
    @State var averageHourlyCost: Double = 0.0
    @State var flatrateHourlyCost:  Double = 0.0
    @State var coefWithCharges:  Double = 0.0
    @State var coefWithoutCharges:  Double = 0.0
    
    var cols = [GridItem(.fixed(250)), GridItem(.flexible())]
    
    var body: some View {
        List {
            LazyVGrid(columns: cols, alignment: .leading, spacing: 15) {
                Text("Average hourly cost")
            
                TextField("Name", value: $averageHourlyCost, formatter: Formatters.decimalFormatter)
           
                Text("Flatrate hourly cost")
                TextField("Email", value: $flatrateHourlyCost, formatter: Formatters.decimalFormatter)
           
                Text("Coefficient with charges")
                TextField("Password", value: $coefWithCharges, formatter: Formatters.decimalFormatter)
            
                Text("Coefficient without charges")
                TextField("Password", value: $coefWithoutCharges, formatter: Formatters.decimalFormatter)
            }
            //.padding()
                    
            HStack {
                Spacer()
                Button("Update cost data") {
                    print("TODO: Create ingredient!")
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
        CostDataSettings()
    }
}
