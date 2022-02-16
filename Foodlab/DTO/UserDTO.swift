//
//  UserDTO.swift
//  Foodlab
//
//  Created by m1 on 16/02/2022.
//

import Foundation

class UserDTO: Identifiable {
    
    var id: Int?
    var name: String
    var email: String
    var password: String
    var isAdmin: Bool
    
    internal init(id: Int? = nil, name: String, email: String, password: String, isAdmin: Bool) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.isAdmin = isAdmin
    }
    
}
