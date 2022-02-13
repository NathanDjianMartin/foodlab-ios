//
//  AdminBadge.swift
//  Foodlab
//
//  Created by Nathan Djian Martin on 13/02/2022.
//

import SwiftUI

struct AdminBadge: View {
    var body: some View {
        Text("Admin")
            .font(.caption)
            .foregroundColor(.white)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.foodlabRed)
            )
    }
}

struct AdminBadge_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AdminBadge()
                .previewLayout(.fixed(width: 100, height: 50))
            AdminBadge()
                .previewLayout(.fixed(width: 100, height: 50))
                .preferredColorScheme(.dark)
        }
       
    }
}
