//
//  RecipeExecution.swift
//  Foodlab
//
//  Created by m1 on 16/02/2022.
//

import Foundation

class RecipeExecution: Step {
    var id: Int?
    var stepTitle: String
    
    //TODO: faire une collection 
    //var steps: [Step] = []
    
    init(id: Int? = nil, stepTitle: String) {
        self.id = id
        self.stepTitle = stepTitle
    }
    
}
