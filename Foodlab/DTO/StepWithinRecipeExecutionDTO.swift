//
//  StepWithinRecipeExecutionDTO.swift
//  Foodlab
//
//  Created by m1 on 26/02/2022.
//

import Foundation

struct StepWithinRecipeExecutionDTO: Identifiable, Decodable {
    
    var id: Int?
    var number: Int
    var recipeExecutionId: Int
    var stepId: Int
    
    init(id: Int? = nil, number: Int, recipeExecutionId: Int, stepId: Int) {
        self.id = id
        self.number = number
        self.recipeExecutionId = recipeExecutionId
        self.stepId = stepId
    }
}
