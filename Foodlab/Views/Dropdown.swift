//
//  Dropdown.swift
//  Foodlab
//
//  Created by Nathan Djian Martin on 02/02/2022.
//

import SwiftUI

struct Dropdown: View {
    @State var value = ""
    var placeholder: String
    var dropDownList: [String]
    var body: some View {
        Menu {
            ForEach(dropDownList, id: \.self) { client in
                Button(client) {
                    self.value = client
                }
            }
        } label: {
            HStack{
                Text(value.isEmpty ? placeholder : value)
                    .foregroundColor(value.isEmpty ? .secondary : .primary)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(Color.gray)
                    .font(Font.system(size: 20, weight: .bold))
            }
            .padding(5)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(.gray, lineWidth: 0.5)
            )
        }
    }
}

struct Dropdown_Previews: PreviewProvider {
    static var previews: some View {
        Dropdown(placeholder: "Select a category", dropDownList: MockData.ingredientCategories)
    }
}
