//
//  RecipeCategory.swift
//  Foodlab
//
//  Created by Nathan Djian Martin on 13/02/2022.
//

import Foundation

class RecipeCategory: Identifiable, CategoryProtocol {
    
    var id: Int?
    var name: String
    
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
