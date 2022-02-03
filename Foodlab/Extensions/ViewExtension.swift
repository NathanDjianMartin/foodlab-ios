//
//  ViewExtension.swift
//  Foodlab
//
//  Created by Nathan Djian Martin on 03/02/2022.
//

import Foundation
import SwiftUI

extension View {
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
