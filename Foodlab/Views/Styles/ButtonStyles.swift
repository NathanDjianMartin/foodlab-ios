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
        withAnimation {
            configuration.label
                .padding(10)
                .background(configuration.isPressed ? Color.foodlabRed.opacity(0.8) : Color.foodlabRed)
                .cornerRadius(10)
                .foregroundColor(.white)
        }
    }
}
