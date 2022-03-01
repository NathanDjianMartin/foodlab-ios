//
//  CategoryDTO.swift
//  Foodlab
//
//  Created by m1 on 16/02/2022.
//

import Foundation

struct CategoryDTO: Identifiable, Codable {
    
    var id: Int?
    var name: String
    
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
