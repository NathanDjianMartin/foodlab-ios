//
//  LoggedUser.swift
//  Foodlab
//
//  Created by m1 on 05/03/2022.
//

import Foundation

class LoggedUser: Identifiable, ObservableObject {
    
    var id: Int?
    @Published var name: String
    @Published var email: String
    @Published var isAdmin: Bool
    @Published var isAuthenticated: Bool
    
    internal init(id: Int? = nil, name: String, email: String, isAdmin: Bool, isAuthenticated: Bool) {
        self.id = id
        self.name = name
        self.email = email
        self.isAdmin = isAdmin
        self.isAuthenticated = isAuthenticated
    }
}
