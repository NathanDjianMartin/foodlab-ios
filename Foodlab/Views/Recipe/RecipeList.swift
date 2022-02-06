//
//  RecipesList.swift
//  Foodlab
//
//  Created by Nathan Djian Martin on 05/02/2022.
//

import SwiftUI

struct RecipeList: View {
    var body: some View {
        List {
            ForEach(1..<30) { number in
                Text("Recipe n°\(number)")
            }
        }
    }
}

struct RecipesList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeList()
            .preferredColorScheme(.dark)
    }
}
