//
//  CostFrame.swift
//  Foodlab
//
//  Created by m1 on 04/03/2022.
//

import SwiftUI

struct CostFrame: View {
    
    var text: String
    var value: Double
    
    var body: some View {
        VStack {
            Text("\(self.text)")
                .foregroundColor(.primary)
            Text("\(self.value.roundTo(2))")
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color("BackgroundColor"))
        .cornerRadius(10)
        .shadow(radius: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 10).fill(Color.foodlabRed).mask(    // << here !!
                HStack {
                    Rectangle().frame(width: 10)
                    Spacer()
                })
                .allowsHitTesting(false))   // << make click-through
        .fixedSize()
        .frame(width: 130, height: 100)
    }

}

struct CostFrame_Previews: PreviewProvider {
    static var previews: some View {
        CostFrame(text: "Charges cost", value: 3)
    }
}
