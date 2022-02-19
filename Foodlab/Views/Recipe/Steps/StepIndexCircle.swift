//
//  StepIndexCircle.swift
//  Foodlab
//
//  Created by Nathan Djian Martin on 18/02/2022.
//

import SwiftUI

struct StepIndexCircle: View {
    var stepNumber: Int
    
    var body: some View {
        Circle()
            .frame(width: 25, height: 24)
            .foregroundColor(.foodlabRed)
            .overlay {
                Text("\(stepNumber)")
                    .foregroundColor(.white)
            }
    }
}

struct StepIndexCircle_Previews: PreviewProvider {
    static var previews: some View {
        StepIndexCircle(stepNumber: 1)
            .previewLayout(.fixed(width: 50, height: 50))
    }
}
