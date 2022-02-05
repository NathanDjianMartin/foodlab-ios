//
//  ButtonStyles.swift
//  Foodlab
//
//  Created by Nathan Djian Martin on 03/02/2022.
//

import Foundation
import SwiftUI

struct DarkRedButtonStyle: ButtonStyle {
        
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(Color.foodlabRed)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
