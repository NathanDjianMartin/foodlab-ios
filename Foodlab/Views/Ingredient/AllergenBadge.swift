//
//  AllergenBadge.swift
//  Foodlab
//
//  Created by Nathan Djian Martin on 05/02/2022.
//

import SwiftUI

struct AllergenBadge: View {
    var body: some View {
        Text("Allergen")
            .font(.caption)
            .foregroundColor(.white)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.foodlabRed)
            )
    }
}

struct AllergenBadge_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AllergenBadge()
                .previewLayout(.fixed(width: 100, height: 50))
            AllergenBadge()
                .previewLayout(.fixed(width: 100, height: 50))
                .preferredColorScheme(.dark)
        }
       
    }
}
