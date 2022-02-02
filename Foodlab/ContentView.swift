//
//  ContentView.swift
//  Foodlab
//
//  Created by Nathan Djian Martin on 02/02/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       IngredientCreation()
            .background(Color("BackgroundColor"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
