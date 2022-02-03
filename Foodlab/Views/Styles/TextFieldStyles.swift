import Foundation
import SwiftUI

struct RoundedTextFieldStyle: TextFieldStyle {
    
    private var color: Color?
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(7)
            .foregroundColor(color ?? .secondary)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(color ?? .secondary, lineWidth: 0.5)
            )
    }
    
    init(color: Color? = nil) {
        self.color = color
    }
}
