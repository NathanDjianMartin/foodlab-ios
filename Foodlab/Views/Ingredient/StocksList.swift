//
//  StocksList.swift
//  Foodlab
//
//  Created by Nathan Djian Martin on 05/02/2022.
//

import SwiftUI

struct StocksList: View {
    var body: some View {
        ScrollView {
            Image("login-bg")
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
            Image("login-bg")
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
            Image("login-bg")
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
            Image("login-bg")
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
        }
        .background(Color("BackgroundColor"))
    }
}

struct StocksList_Previews: PreviewProvider {
    static var previews: some View {
        StocksList()
    }
}
