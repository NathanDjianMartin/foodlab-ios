//
//  credentialsDTO.swift
//  Foodlab
//
//  Created by m1 on 04/03/2022.
//

import Foundation

class CredentialsDTO : Codable {
    var email: String
    var password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
