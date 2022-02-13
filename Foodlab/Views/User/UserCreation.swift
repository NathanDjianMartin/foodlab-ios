//
//  UserCreation.swift
//  Foodlab
//
//  Created by Nathan Djian Martin on 13/02/2022.
//

import SwiftUI

struct UserCreation: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isAdmin: Bool = false
    
    private var columns = [GridItem(.adaptive(minimum: 300))]
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Name")
                    Divider()
                    TextField("Name", text: $name)
                }
                
                HStack {
                    Text("Email")
                    Divider()
                    TextField("Email", text: $email)
                }
                
                HStack {
                    Text("Password")
                    Divider()
                    TextField("Password", text: $password)
                }
                
                HStack {
                    Text("Admin")
                    Toggle(isOn: $isAdmin) {
                        
                    }
                }
                
                HStack {
                    Spacer()
                    Button("Create user") {
                        print("TODO: Create ingredient!")
                    }
                    .buttonStyle(DarkRedButtonStyle())
                }
                .padding(.bottom)
                
            }
            .navigationTitle("Add a user")
            .listStyle(.plain)
            .padding()
        }
    }
}

struct UserCreation_Previews: PreviewProvider {
    static var previews: some View {
        UserCreation()
            .preferredColorScheme(.dark)
    }
}
