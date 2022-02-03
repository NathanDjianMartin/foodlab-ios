//
//  RoundedTextFieldStyle.swift
//  Foodlab
//
//  Created by Nathan Djian Martin on 02/02/2022.
//

import Foundation
import SwiftUI

struct RoundedTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(7)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.secondary, lineWidth: 0.5)
            )
    }
}
