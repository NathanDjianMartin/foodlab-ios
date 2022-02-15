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
    
    var body: some View {
        List {
            HStack {
                Text("Average hourly cost")
                Divider()
                TextField("Name", value: $averageHourlyCost, formatter: Formatters.decimalFormatter)
            }
            
            HStack {
                Text("Flatrate hourly cost")
                Divider()
                TextField("Email", value: $flatrateHourlyCost, formatter: Formatters.decimalFormatter)
            }
            
            HStack {
                Text("Coefficient with charges")
                Divider()
                TextField("Password", value: $coefWithCharges, formatter: Formatters.decimalFormatter)
            }
            
            HStack {
                Text("Coefficient without charges")
                Divider()
                TextField("Password", value: $coefWithoutCharges, formatter: Formatters.decimalFormatter)
            }
            
            HStack {
                Spacer()
                Button("Update cost data") {
                    print("TODO: Create ingredient!")
                }
                .buttonStyle(DarkRedButtonStyle())
            }
        }
        .listStyle(.plain)
        .padding()
    }
}

struct CostDataSettings_Previews: PreviewProvider {
    static var previews: some View {
        CostDataSettings()
    }
}
