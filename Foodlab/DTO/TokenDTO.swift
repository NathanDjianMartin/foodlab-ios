//
//  TokenDTO.swift
//  Foodlab
//
//  Created by m1 on 04/03/2022.
//

import Foundation

class TokenDTO : Codable {
    var access_token: String
    
    init(access_token: String) {
        self.access_token = access_token
    }
}
