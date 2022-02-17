//
//  RecipeDTO.swift
//  Foodlab
//
//  Created by m1 on 16/02/2022.
//

import Foundation

struct RecipeDTO: Identifiable {
    
    var id: Int?
    var name: String
    var author: String
    var guestsNumber: Int
    var recipeCategoryId: Int
    var recipeExecutionId: Int?
    var costDataId: Int
    
    //variable calculée
    var duration : Int
    
    internal init(id: Int? = nil, name: String, author: String, guestsNumber: Int, recipeCategoryId: Int, recipeExecutionId: Int? = nil, costDataId: Int, duration: Int) {
        self.id = id
        self.name = name
        self.author = author
        self.guestsNumber = guestsNumber
        self.recipeCategoryId = recipeCategoryId
        self.recipeExecutionId = recipeExecutionId
        self.costDataId = costDataId
        self.duration = duration
    }
    
}
